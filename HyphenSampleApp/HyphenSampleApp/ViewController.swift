import Flow
import HyphenAuthenticate
import HyphenCore
import HyphenFlow
import HyphenNetwork
import SnapKit
import UIKit

class ViewController: UIViewController {
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var titleLabel: UILabel!
    var descriptionLabel: UILabel!

    var networkSelector: UISegmentedControl!

    var step1TitleLabel: UILabel!
    var loginWithGoogleButton: UIButton!

    var flowAccountTitleLabel: UILabel!
    var flowAccountDescriptionLabel: UILabel!

    var signTransactionTitleLabel: UILabel!
    var signTransactionResultLabel: UILabel!
    var signTransactionButton: UIButton!

    var keyManagerTitleLabel: UILabel!
    var keyManagerButton: UIButton!

    var loadingIndicatorContainer: UIView?
    var loadingIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        makeTitleBar()
        makeNetworkSelector()
        drawStep1()
        drawFlowAccount()
        drawSignTransaction()
        drawKeyManager()
    }

    @objc func didNetworkChangeValue(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            Hyphen.shared.network = .testnet
        } else {
            Hyphen.shared.network = .mainnet
        }

        print("===== [HyphenSDKDemo] Change flow / hyphen network = \(Hyphen.shared.network)")
    }

    @objc func loginWithGoogle() {
        showLoadingIndicator()

        DispatchQueue.main.async {
            Task {
                do {
                    try await HyphenAuthenticate.shared.authenticate(provider: .google)

                    let account = try await HyphenNetworking.shared.getMyAccount()

                    self.flowAccountDescriptionLabel.text = "Flow network: \(Hyphen.shared.network)\nFlow Account Address: \(account.addresses.first!.address)"
                    self.flowAccountDescriptionLabel.sizeToFit()
                    self.flowAccountDescriptionLabel.snp.updateConstraints { make in
                        make.height.equalTo(self.flowAccountDescriptionLabel.intrinsicContentSize.height)
                    }

                    self.hideLoadingIndicator()
                } catch {
                    print(error)
                    self.hideLoadingIndicator()
                }
            }
        }
    }

    @objc func signTransactionAndSend() {
        showLoadingIndicator()

        let cadence = HyphenFlowCadence(
            cadence: """
            import HelloWorld from 0xe242ccfb4b8ea3e2

            transaction(test: String, testInt: HelloWorld.SomeStruct) {
                prepare(signer1: AuthAccount, signer2: AuthAccount, signer3: AuthAccount) {
                     log(signer1.address)
                     log(signer2.address)
                     log(signer3.address)
                     log(test)
                     log(testInt)
                }
            }
            """
        )

        Task {
            do {
                let transaction = try await HyphenFlow.shared.makeSignedTransactionPayloadWithArguments(
                    hyphenFlowCadence: cadence,
                    args: [
                        .string("Test"),
                        .struct(
                            .init(
                                id: "A.e242ccfb4b8ea3e2.HelloWorld.SomeStruct",
                                fields: [
                                    .init(
                                        name: "x",
                                        value: .init(
                                            value: .int(1)
                                        )
                                    ),
                                    .init(
                                        name: "y",
                                        value: .init(
                                            value: .int(2)
                                        )
                                    ),
                                ]
                            )
                        ),
                    ]
                )

                let txHash = try await HyphenFlow.shared.sendSignedTransaction(transaction)
                signTransactionResultLabel.text = "TxHash -> \(txHash)"

                hideLoadingIndicator()

                DispatchQueue.main.async {
                    UIApplication.shared.open(URL(string: "https://flow-view-source.com/testnet/tx/\(txHash)")!)
                }
            } catch {
                print(error)
                hideLoadingIndicator()
            }
        }
    }

    @objc func openKeyManager() {
        Hyphen.shared.openKeyManager()
    }
}

// MARK: - UILabel line height

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        guard let text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()

        style.lineSpacing = lineHeight
        attributeString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: style,
            range: NSMakeRange(0, attributeString.length)
        )

        attributedText = attributeString
    }
}
