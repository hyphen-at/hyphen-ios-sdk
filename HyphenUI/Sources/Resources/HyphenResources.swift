import Foundation

private class BundleFinder {}

extension Foundation.Bundle {
    static let hyphenColorResource: Bundle = {
        let bundleName = "Hyphen_HyphenUI"

        let overrides: [URL]
        #if DEBUG
            if let override = ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_URL"] {
                overrides = [URL(fileURLWithPath: override)]
            } else {
                overrides = []
            }
        #else
            overrides = []
        #endif

        let candidates = overrides + [
            Bundle.main.resourceURL,
            Bundle(for: BundleFinder.self).resourceURL,
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named Hyphen_HyphenUI")
    }()
}
