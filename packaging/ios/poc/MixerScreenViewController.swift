import UIKit
import SwiftUI

final class MixerScreenViewController: UIViewController {
    private let bridge = MixxxEngineBridge()

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = MixerScreenViewModel(bridge: bridge)
        let mixerView = MixerScreenView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: mixerView)

        addChild(hosting)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hosting.view)

        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        hosting.didMove(toParent: self)
    }
}
