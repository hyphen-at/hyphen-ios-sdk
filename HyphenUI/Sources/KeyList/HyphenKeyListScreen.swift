import HyphenCore
import SwiftUI

struct HyphenKeyListScreen: View {
    @StateObject var state: HyphenKeyListState = .init()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if !state.isLoading {
                    List {
                        ForEach(state.keys, id: \.self) { key in
                            HyphenKeyItem(key: key)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                        }
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                            .background(Color(red: 0.89, green: 0.89, blue: 0.89))
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                } else {
                    ProgressView()
                        .controlSize(.large)
                }
            }
            .navigationTitle(Text("Key Manager"))
            .navigationBarBackButtonHidden(false)
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(.black)
        }
    }
}

struct HyphenKeyItem: View {
    let key: HyphenKey

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                .background(Color(red: 0.89, green: 0.89, blue: 0.89))
                .padding(.top, 20)
            HStack(alignment: .top, spacing: 10) {
                if key.type == .serverKey {
                    Image("cloudy", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                } else if key.type == .userKey {
                    Image("key", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                VStack(spacing: 6) {
                    HStack {
                        Text(key.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.06, green: 0.06, blue: 0.06))
                        Spacer()
                    }
                    HStack {
                        Text("Last Used: \(formatDate(stringToDate(from: key.lastUsedAt)!))")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        Spacer()
                    }
                    HStack {
                        Text(key.type == .serverKey ? "SERVER KEY" : "DEVICE KEY")
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let day = dayFormatter.string(from: date)

        let suffix: String
        switch day {
        case "01", "21", "31": suffix = "st"
        case "02", "22": suffix = "nd"
        case "03", "23": suffix = "rd"
        default: suffix = "th"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy HH:mm"
        return day + suffix + " " + dateFormatter.string(from: date)
    }

    private func stringToDate(from string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string)
    }
}

#if DEBUG
    struct HyphenKeyListScreen_Preview: PreviewProvider {
        static var previews: some View {
            let state = HyphenKeyListState()

            HyphenKeyListScreen(
                state: state
            )
            .onAppear {
                state.keys = [
                    HyphenKey(
                        publicKey: "00000000000000000000",
                        type: .serverKey,
                        name: "Hyphen Server Key",
                        keyIndex: 0,
                        userKey: nil,
                        recoverKey: nil,
                        lastUsedAt: "2023-07-22T19:43:25.122Z"
                    ),
                    HyphenKey(
                        publicKey: "0000000000000",
                        type: .userKey,
                        name: "iPhone 13 on Swirl",
                        keyIndex: 2,
                        userKey: HyphenUserKey(
                            type: .device,
                            device: HyphenDevice(
                                id: "000000000000000000000000",
                                publicKey: "000000000000000000000000",
                                pushToken: "xxxxxxxxxxxxx",
                                name: "iPhone",
                                osName: .iOS,
                                osVersion: "16.5.1",
                                deviceManufacturer: "Apple",
                                deviceModel: "iPhone 13",
                                lang: "en-KR",
                                type: .mobile
                            ), publicKey: nil,
                            wallet: nil
                        ),
                        recoverKey: nil,
                        lastUsedAt: "2023-07-24T09:00:58.524Z"
                    ),
                ]
            }
        }
    }
#endif
