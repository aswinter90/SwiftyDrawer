import SwiftUI

struct TabBarRepresentable: UIViewControllerRepresentable {
    var isHidden: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            updateTabBar(in: viewController)
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            updateTabBar(in: uiViewController)
        }
    }

    private func updateTabBar(in viewController: UIViewController) {
        viewController.tabBarController?.tabBar.isHidden = isHidden
    }
}
