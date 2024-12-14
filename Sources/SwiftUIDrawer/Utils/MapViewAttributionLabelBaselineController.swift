//import Combine
//import Foundation
//
//@MainActor
//public final class MapViewAttributionLabelBaselineController {
//    private let applicationStateObserver: ApplicationStateObserver
//
//    public let drawerOriginObservable = DrawerOriginObservable()
//    public weak var map: Map?
//
//    public init(
//        map: Map,
//        applicationStateObserver: ApplicationStateObserver = .init()
//    ) {
//        self.map = map
//        self.applicationStateObserver = applicationStateObserver
//        setupBindings()
//    }
//
//    private func setupBindings() {
//        Task {
//            await self.applicationStateObserver.setWillEnterForegroundAction { [weak self] in
//                if let drawerOrigin = self?.drawerOriginObservable.origin {
//                    self?.map?.setAttributionLabelBaseline(to: drawerOrigin.y)
//                }
//            }
//
//            for await origin in drawerOriginObservable.$origin.values.compactMap({ $0 }) {
//                map?.setAttributionLabelBaseline(to: origin.y)
//            }
//        }
//    }
//}
