import HyphenCore
import SwiftUI

struct Hyphen2FAView: View {
    let twoFactorAuth: Hyphen2FAStatus

    @StateObject var state: Hyphen2FAState = .init()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    if let appIcon = Bundle.main.icon {
                        Image(uiImage: appIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .inset(by: 0.5)
                                    .stroke(
                                        Color(red: 0.74, green: 0.76, blue: 0.79), lineWidth: 1
                                    )
                            )

                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .inset(by: 0.5)
                                    .stroke(
                                        Color(red: 0.74, green: 0.76, blue: 0.79), lineWidth: 1
                                    )
                            )
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 26)

                HStack {
                    Text("\(state.twoFactorAuth?.request.app.appName ?? "") requires to\nSign-In")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color(red: 0.06, green: 0.06, blue: 0.06))
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 20)
                HStack {
                    Text("\(state.twoFactorAuth?.request.srcDevice.deviceModel ?? "") is trying to sign-in into \(state.twoFactorAuth?.request.app.appName ?? "") in the \(state.twoFactorAuth?.request.userOpInfo.signIn.email ?? "") account.")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.12, green: 0.14, blue: 0.16))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)

                Spacer()

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Device")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 0.06, green: 0.06, blue: 0.06))
                        Spacer()
                    }
                    HStack {
                        Text(state.twoFactorAuth?.request.srcDevice.deviceModel ?? "")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        Spacer()
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 24)

                    HStack {
                        Text("App Name")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 0.06, green: 0.06, blue: 0.06))
                        Spacer()
                    }
                    HStack {
                        Text(state.twoFactorAuth?.request.app.appName ?? "")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        Spacer()
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 24)

                    HStack {
                        Text("Near")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 0.06, green: 0.06, blue: 0.06))
                        Spacer()
                    }
                    HStack {
                        Text(state.twoFactorAuth?.request.userOpInfo.signIn.location ?? "")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        Spacer()
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 24)

                    HStack {
                        Text("Time")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 0.06, green: 0.06, blue: 0.06))
                        Spacer()
                    }
                    HStack {
                        Text("Just now")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        Spacer()
                    }
                    .padding(.top, 4)
                }
                .padding(20)
                .background(Color(red: 0.94, green: 0.94, blue: 0.95))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.89, green: 0.89, blue: 0.89), lineWidth: 1)
                )
                .padding(.horizontal, 16)

                HStack(spacing: 8) {
                    Button(action: {}) {
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
                    Button(action: {}) {
                        HStack(alignment: .bottom, spacing: 8) {
                            Spacer()
                            Text("Approve\(state.remainingTimeText)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(red: 0.98, green: 0.98, blue: 0.98))
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.12, green: 0.58, blue: 0.94))
                        .cornerRadius(12)
                    }
                    .disabled(state.remainingTimeSeconds == 0)
                }
                .padding(.top, 28)
                .padding(.horizontal, 16)
                .padding(.bottom, 18)
            }
            .onAppear {
                self.state.twoFactorAuth = twoFactorAuth
            }
            
            if state.isProcessing {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if #available(iOS 15.0, *) {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .controlSize(.regular)
                        } else {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        Spacer()
                    }
                }
                .background(Color.white.opacity(0.3))
                .allowsHitTesting(true)
                .animation(.easeInOut, value: state.isProcessing)
            }
        }
    }
}

#if DEBUG
    struct Hyphen2FAView_Previews: PreviewProvider {
        static var previews: some View {
            let state = Hyphen2FAState()

            Hyphen2FAView(
                twoFactorAuth: Hyphen2FAStatus(
                    id: "1",
                    accountId: "1",
                    request: Hyphen2FARequest(
                        id: "faceb00c-cafe-babe-badd-deadbeef1234",
                        app: HyphenAppInformation(
                            appId: "swirl-dev",
                            appName: "Swirl"
                        ),
                        userOpInfo: Hyphen2FAUserOpInfo(
                            type: "sign-in",
                            signIn: Hyphen2FAUserOpInfo.SignIn(
                                location: "Seoul, KR",
                                ip: "127.0.0.1",
                                email: "john@acme.com"
                            )
                        ),
                        srcDevice: HyphenDevice(
                            id: "deadbeef-dead-beef-cafe-deadbeefcafe",
                            publicKey: "faceb00ccafebabedeadbeefbadf00defaceb00ccafebabedeadbeefbadf00de",
                            pushToken: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...",
                            name: "iPhone 14",
                            osName: .iOS,
                            osVersion: "16.2",
                            deviceManufacturer: "Apple",
                            deviceModel: "SM-265N",
                            lang: "en",
                            type: .mobile
                        ),
                        destDevice: HyphenDevice(
                            id: "deadbeef-dead-beef-cafe-deadbeefcafe",
                            publicKey: "faceb00ccafebabedeadbeefbadf00defaceb00ccafebabedeadbeefbadf00de",
                            pushToken: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...",
                            name: "iPhone 14",
                            osName: .iOS,
                            osVersion: "16.2",
                            deviceManufacturer: "Apple",
                            deviceModel: "SM-265N",
                            lang: "en",
                            type: .mobile
                        ),
                        requestedAt: "2021-01-01T00:00:00Z",
                        message: "deadbeefdeadbeefdeadbeef"
                    ),
                    status: .pending,
                    expiresAt: "2021-01-01T00:00:00Z", result: Hyphen2FAStatus.Result(
                        signature: "string"
                    )
                ), state: state
            )
        }
    }
#endif
