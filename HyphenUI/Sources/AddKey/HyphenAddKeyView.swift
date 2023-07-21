import SwiftUI

struct HyphenAddKeyView: View {
    @StateObject var state: HyphenAddKeyState = .init()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(state.requestDeviceName) is trying to\nAdd the Key")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color(red: 0.06, green: 0.06, blue: 0.06))
                Spacer()
            }
            .padding(.top, 28)
            .padding(.horizontal, 20)
            HStack {
                Text("\(state.requestDeviceName) is trying to add the key in the \(state.requestEmail) account.")
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
                    Text(state.requestDeviceName)
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    Spacer()
                }
                .padding(.top, 4)
                .padding(.bottom, 24)

                HStack {
                    Text("Key Name")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.06, green: 0.06, blue: 0.06))
                    Spacer()
                }
                HStack {
                    Text(state.keyName)
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
                    Text(state.near)
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
            }
            .padding(.top, 28)
            .padding(.horizontal, 16)
            .padding(.bottom, 18)
        }
    }
}

#if DEBUG
    struct HyphenAddKeyView_Previews: PreviewProvider {
        static var previews: some View {
            let state = HyphenAddKeyState()

            HyphenAddKeyView(
                state: state
            )
            .onAppear {
                state.appName = "SWIRL"
                state.requestDeviceName = "iPhone 14 Pro"
                state.requestEmail = "dora@meowauth.xyz"
                state.keyName = "SWIRL iPhone 14 Pro Device Key"
                state.near = "Seoul, Rep.Korea"
            }
        }
    }
#endif
