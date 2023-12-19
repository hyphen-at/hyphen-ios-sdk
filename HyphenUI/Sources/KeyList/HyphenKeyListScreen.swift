import HyphenCore
import NativePartialSheet
import SwiftUI

struct HyphenKeyListScreen: View {
    @StateObject var state: HyphenKeyListState = .init()

    @State var detent: Detent = .height(270)

    var body: some View {
        ZStack {
            List {
                ForEach(state.keys, id: \.self) { key in
                    HyphenKeyItem(key: key)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .swipeActions {
                            if key.publicKey != HyphenCryptography.getPublicKeyHex(), key.type == .userKey {
                                Button(action: {
                                    state.pendingRevokeKey(key)
                                }) {
                                    Text("Revoke")
                                }
                                .tint(Color("HyphenRevokeBackgroundColor", bundle: .hyphenColorResource))
                            }
                        }
                }
            }
            .listStyle(.plain)

            if state.isLoading {
                ZStack {
                    ProgressView()
                        .controlSize(.large)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.black.opacity(0.1))
                .allowsHitTesting(true)
            }

            Color.clear
                .sheet(isPresented: $state.isShowRevokeKeyConfirmSheet) {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Revoke Key")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color("HyphenPrimaryLabelColor", bundle: .hyphenColorResource))
                            Spacer()
                        }
                        HStack {
                            Text("Are you sure revoke the key?")
                                .font(.system(size: 16))
                                .foregroundColor(Color("HyphenSecondaryLabelColor", bundle: .hyphenColorResource))
                            Spacer()
                        }
                        .padding(.top, 6)
                        .padding(.bottom, 20)
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Key Name")
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                            }
                            HStack {
                                Text(state.pendingRevokeKey?.name ?? "")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color("HyphenSecondaryLabelColor", bundle: .hyphenColorResource))
                                Spacer()
                            }
                        }
                        .padding(20)
                        .background(Color("HyphenPanelBackgroundColor", bundle: .hyphenColorResource))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: 0.5)
                                .stroke(Color("HyphenPanelBorderColor", bundle: .hyphenColorResource), lineWidth: 1)
                        )
                        HStack(spacing: 8) {
                            Button(action: {
                                state.pendingRevokeKey(nil)
                            }) {
                                HStack(alignment: .bottom, spacing: 8) {
                                    Spacer()
                                    Text("Refuse")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(red: 0.12, green: 0.58, blue: 0.94))
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.94, green: 0.94, blue: 0.95))
                                .cornerRadius(12)
                            }
                            Button(action: {
                                state.revokeKey()
                            }) {
                                HStack(alignment: .bottom, spacing: 8) {
                                    Spacer()
                                    Text("Approve")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.12, green: 0.58, blue: 0.94))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.top, 28)
                        .padding(.bottom, 18)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 44)
                    .padding(.bottom, 18)
                }
                .presentationDetents([$detent.wrappedValue], selection: $detent)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled(
                    false,
                    onWillDismiss: {},
                    onDidDismiss: {
                        state.pendingRevokeKey(nil)
                    }
                )
                .allowsHitTesting(false)
        }
        .accentColor(.black)
    }
}

struct HyphenKeyItem: View {
    let key: HyphenKey

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                if key.type == .serverKey {
                    Image("cloudy", bundle: .module)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color("HyphenCloudIconTintColor", bundle: .hyphenColorResource))
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                } else if key.type == .userKey {
                    Image("key", bundle: .module)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color("HyphenKeyIconTintColor", bundle: .hyphenColorResource))
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                VStack(spacing: 6) {
                    HStack {
                        Text(key.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("HyphenPrimaryLabelColor", bundle: .hyphenColorResource))
                        Spacer()
                    }
                    HStack {
                        Text("Last Used: \(formatDate(stringToDate(from: key.lastUsedAt)!))")
                            .font(.system(size: 12))
                            .foregroundColor(Color("HyphenSecondaryLabelColor", bundle: .hyphenColorResource))
                        Spacer()
                    }
                    HStack {
                        Text(key.type == .serverKey ? "SERVER KEY" : key.type == .recoverKey ? "RECOVERY KEY" : "DEVICE KEY")
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundColor(Color("HyphenSecondaryLabelColor", bundle: .hyphenColorResource))
                            .padding(.bottom, 20)
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                .background(Color("HyphenDividerColor", bundle: .hyphenColorResource))
                .padding(.leading, 44)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let day = dayFormatter.string(from: date)

        let suffix = switch day {
        case "01", "21", "31": "st"
        case "02", "22": "nd"
        case "03", "23": "rd"
        default: "th"
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

extension HyphenKeyListScreen: SwiftUIViewHostingCompatible {
    func transformNavigationController(_ navigationController: UINavigationController) {
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationController.navigationBar.backItem?.title = ""
        navigationController.navigationBar.tintColor = .init(named: "HyphenCommonAppBarTintColor", in: .hyphenColorResource, compatibleWith: .current)
        navigationController.isNavigationBarHidden = false
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
