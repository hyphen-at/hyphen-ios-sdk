import HyphenCore
import SwiftUI
import UIKit

public class HyphenKeyListViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()

        title = "Key Manager"

        let hostingController = UIHostingController(rootView: HyphenKeyListScreen().hostingControllerPresentor())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
    }
}
