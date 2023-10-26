import Foundation
import HyphenCore
import HyphenNetwork
import UIKit

extension ViewController {
    // MARK: - Loading Indicator View

    func showLoadingIndicator() {
        loadingIndicatorContainer = UIView()
        loadingIndicatorContainer!.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        loadingIndicatorContainer!.alpha = 0
        view.addSubview(loadingIndicatorContainer!)
        loadingIndicatorContainer!.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }

        loadingIndicator = UIActivityIndicatorView()
        loadingIndicator!.style = .large
        loadingIndicator!.startAnimating()
        loadingIndicatorContainer!.addSubview(loadingIndicator!)
        loadingIndicator!.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        UIView.animate(withDuration: 0.3) {
            self.loadingIndicatorContainer!.alpha = 1
        }
    }

    func hideLoadingIndicator() {
        loadingIndicator!.stopAnimating()
        loadingIndicatorContainer!.removeFromSuperview()
        loadingIndicatorContainer = nil
        loadingIndicator = nil
    }

    // MARK: - Network Selector

    func makeNetworkSelector() {
        networkSelector = UISegmentedControl(items: ["TestNet", "MainNet"])
        networkSelector.selectedSegmentIndex = 0
        networkSelector.addTarget(self, action: #selector(didNetworkChangeValue(segment:)), for: .valueChanged)
        view.addSubview(networkSelector)
        networkSelector.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width - 32)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Title Bar

    func makeTitleBar() {
        titleLabel = UILabel()
        titleLabel.text = "Hyphen SDK Demo"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label

        scrollView.addSubview(titleLabel)

        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.leading.equalTo(16)
        }

        descriptionLabel = UILabel()
        descriptionLabel.text = "This is the sample code for the Hyphen iOS SDK.\n\nThe Hyphen SDK already includes 2FA verification feature. After installing demo app on another device, you can test it by logging in using the same account."
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .label
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setLineHeight(lineHeight: 2)
        descriptionLabel.contentMode = .scaleToFill
        descriptionLabel.preferredMaxLayoutWidth = view.frame.width - 32
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.sizeToFit()

        scrollView.addSubview(descriptionLabel)

        descriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width - 32)
            make.centerX.equalToSuperview()
            make.height.equalTo(descriptionLabel.intrinsicContentSize.height)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }

    // MARK: - Step 1

    func drawStep1() {
        step1TitleLabel = UILabel()
        step1TitleLabel.text = "Login with Google"
        step1TitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        step1TitleLabel.textColor = .label

        scrollView.addSubview(step1TitleLabel)

        step1TitleLabel.sizeToFit()
        step1TitleLabel.snp.makeConstraints { make in
            make.top.equalTo(networkSelector.snp.bottom).offset(36)
            make.leading.equalTo(16)
        }

        loginWithGoogleButton = UIButton(type: .system)
        loginWithGoogleButton.setTitle("Login with Google", for: .normal)
        loginWithGoogleButton.titleLabel!.font = .systemFont(ofSize: 14, weight: .regular)
        loginWithGoogleButton.setTitleColor(.tintColor, for: .normal)
        scrollView.addSubview(loginWithGoogleButton)
        loginWithGoogleButton.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(step1TitleLabel.snp.bottom).offset(6)
        }
        loginWithGoogleButton.addTarget(self, action: #selector(loginWithGoogle), for: .touchUpInside)
    }

    // MARK: - Flow account label

    func drawFlowAccount() {
        flowAccountTitleLabel = UILabel()
        flowAccountTitleLabel.text = "Login Result (Flow Account)"
        flowAccountTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        flowAccountTitleLabel.textColor = .label

        scrollView.addSubview(flowAccountTitleLabel)

        flowAccountTitleLabel.sizeToFit()
        flowAccountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(loginWithGoogleButton.snp.bottom).offset(36)
            make.leading.equalTo(16)
        }

        flowAccountDescriptionLabel = UILabel()
        flowAccountDescriptionLabel.text = "Unauthorized"
        flowAccountDescriptionLabel.font = .systemFont(ofSize: 15)
        flowAccountDescriptionLabel.textColor = .label
        flowAccountDescriptionLabel.textAlignment = .left
        flowAccountDescriptionLabel.numberOfLines = 0
        flowAccountDescriptionLabel.setLineHeight(lineHeight: 2)
        flowAccountDescriptionLabel.contentMode = .scaleToFill
        flowAccountDescriptionLabel.preferredMaxLayoutWidth = view.frame.width - 32
        flowAccountDescriptionLabel.lineBreakMode = .byWordWrapping
        flowAccountDescriptionLabel.sizeToFit()

        scrollView.addSubview(flowAccountDescriptionLabel)

        flowAccountDescriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width - 32)
            make.centerX.equalToSuperview()
            make.height.equalTo(flowAccountDescriptionLabel.intrinsicContentSize.height)
            make.top.equalTo(flowAccountTitleLabel.snp.bottom).offset(8)
        }
    }

    // MARK: - Sign Transaction

    func drawSignTransaction() {
        signTransactionTitleLabel = UILabel()
        signTransactionTitleLabel.text = "Sign & Send Transaction"
        signTransactionTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        signTransactionTitleLabel.textColor = .label

        scrollView.addSubview(signTransactionTitleLabel)

        signTransactionTitleLabel.sizeToFit()
        signTransactionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(flowAccountDescriptionLabel.snp.bottom).offset(36)
            make.leading.equalTo(16)
        }

        signTransactionButton = UIButton(type: .system)
        signTransactionButton.setTitle("Signing Transaction and Send", for: .normal)
        signTransactionButton.titleLabel!.font = .systemFont(ofSize: 14, weight: .regular)
        signTransactionButton.setTitleColor(.tintColor, for: .normal)
        scrollView.addSubview(signTransactionButton)
        signTransactionButton.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(signTransactionTitleLabel.snp.bottom).offset(6)
        }
        signTransactionButton.addTarget(self, action: #selector(signTransactionAndSend), for: .touchUpInside)

        signTransactionResultLabel = UILabel()
        signTransactionResultLabel.text = ""
        signTransactionResultLabel.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
        signTransactionResultLabel.textColor = .label
        signTransactionResultLabel.textAlignment = .left
        signTransactionResultLabel.numberOfLines = 0
        signTransactionResultLabel.setLineHeight(lineHeight: 2)
        signTransactionResultLabel.contentMode = .scaleToFill
        signTransactionResultLabel.preferredMaxLayoutWidth = view.frame.width - 32
        signTransactionResultLabel.lineBreakMode = .byWordWrapping
        signTransactionResultLabel.sizeToFit()

        scrollView.addSubview(signTransactionResultLabel)

        signTransactionResultLabel.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width - 32)
            make.centerX.equalToSuperview()
            make.height.equalTo(signTransactionButton.intrinsicContentSize.height)
            make.top.equalTo(signTransactionButton.snp.bottom).offset(8)
        }
    }

    // MARK: - Key Manager

    func drawKeyManager() {
        keyManagerTitleLabel = UILabel()
        keyManagerTitleLabel.text = "Key Manager"
        keyManagerTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        keyManagerTitleLabel.textColor = .label

        scrollView.addSubview(keyManagerTitleLabel)

        keyManagerTitleLabel.sizeToFit()
        keyManagerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(signTransactionResultLabel.snp.bottom).offset(36)
            make.leading.equalTo(16)
        }

        keyManagerButton = UIButton(type: .system)
        keyManagerButton.setTitle("Open Key Manager", for: .normal)
        keyManagerButton.titleLabel!.font = .systemFont(ofSize: 14, weight: .regular)
        keyManagerButton.setTitleColor(.tintColor, for: .normal)
        scrollView.addSubview(keyManagerButton)
        keyManagerButton.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(keyManagerTitleLabel.snp.bottom).offset(6)
        }
        keyManagerButton.addTarget(self, action: #selector(openKeyManager), for: .touchUpInside)
    }
}
