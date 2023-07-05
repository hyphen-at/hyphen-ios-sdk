import Foundation
import Logging

@_spi(HyphenInternal)
public struct HyphenFileHandlerOutputStream: TextOutputStream {
    enum FileHandlerOutputStream: Error {
        case couldNotCreateFile
    }

    private let fileHandle: FileHandle
    let encoding: String.Encoding

    init(localFile url: URL, encoding: String.Encoding = .utf8) throws {
        if !FileManager.default.fileExists(atPath: url.path) {
            guard FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil) else {
                throw FileHandlerOutputStream.couldNotCreateFile
            }
        }

        let fileHandle = try FileHandle(forWritingTo: url)
        fileHandle.seekToEndOfFile()
        self.fileHandle = fileHandle
        self.encoding = encoding
    }

    public mutating func write(_ string: String) {
        if let data = string.data(using: encoding) {
            fileHandle.write(data)
        }
    }
}

@_spi(HyphenInternal)
public struct HyphenFileLogging {
    let stream: TextOutputStream
    private var localFile: URL

    public init(to localFile: URL) throws {
        stream = try HyphenFileHandlerOutputStream(localFile: localFile)
        self.localFile = localFile
    }

    public func handler(label: String) -> HyphenFileLogHandler {
        return HyphenFileLogHandler(label: label, fileLogger: self)
    }

    public static func logger(label: String, localFile url: URL) throws -> Logger {
        let logging = try HyphenFileLogging(to: url)
        return Logger(label: label, factory: logging.handler)
    }
}

@_spi(HyphenInternal)
public struct HyphenFileLogHandler: LogHandler {
    private let stream: TextOutputStream
    private var label: String

    public var logLevel: Logger.Level = .info

    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            prettyMetadata = prettify(metadata)
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return metadata[metadataKey]
        }
        set {
            metadata[metadataKey] = newValue
        }
    }

    public init(label: String, fileLogger: HyphenFileLogging) {
        self.label = label
        stream = fileLogger.stream
    }

    public init(label: String, localFile url: URL) throws {
        self.label = label
        stream = try HyphenFileHandlerOutputStream(localFile: url)
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    source _: String,
                    file _: String,
                    function _: String,
                    line _: UInt)
    {
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))

        var stream = self.stream
        stream.write("\(timestamp()) \(level) \(label) :\(prettyMetadata.map { " \($0)" } ?? "") \(message)\n")
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }

    private func timestamp() -> String {
        var buffer = [Int8](repeating: 0, count: 255)
        var timestamp = time(nil)
        let localTime = localtime(&timestamp)
        strftime(&buffer, buffer.count, "%Y-%m-%dT%H:%M:%S%z", localTime)
        return buffer.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) {
                String(cString: $0.baseAddress!)
            }
        }
    }
}
