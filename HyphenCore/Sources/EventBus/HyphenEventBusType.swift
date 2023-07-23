import RealEventsBus

@_spi(HyphenInternal)
public enum HyphenEventBusType: Event {
    case show2FAWaitingProgressModal(isShow: Bool)
}
