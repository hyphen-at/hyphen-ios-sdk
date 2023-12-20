import RealEventsBus

@_spi(HyphenInternal)
public enum HyphenEventBusType: Event {
    case show2FAWaitingProgressModal(isShow: Bool)
    case twoFactorAuthDenied
    case twoFactorAuthApproved(requestId: String)

    case showAccountRecoveryMethodModal
    case selectAccountRecoveryMethod2FA
    case selectAccountRecoveryMethodRecoveryKey
}
