import Foundation
import MapKit
import SwiftyDrawer

@Observable class ViewModel {
    enum State {
        case overview(region: MKCoordinateRegion, annotations: [AnnotationModel])
        case selectedAnnotation(_ annotation: AnnotationModel)

        var region: MKCoordinateRegion {
            switch self {
            case .overview(let region, _):
                region
            case .selectedAnnotation(let model):
                model.region
            }
        }

        static var defaultOverview: Self {
            Self.overview(region: MapData.germanyRegion, annotations: MapData.annotations)
        }
    }

    var state: State

    init(state: State = State.defaultOverview) {
        self.state = state
    }

    func didSelectAnnotation(_ annotation: AnnotationModel) {
        state = .selectedAnnotation(annotation)
    }

    func didReturn() {
        state = State.defaultOverview
    }
}

extension ViewModel.State: Equatable {
    static func == (lhs: ViewModel.State, rhs: ViewModel.State) -> Bool {
        return switch (lhs, rhs) {
        case let (.overview(lhsRegion, lhsAnnotations), .overview(rhsRegion, rhsAnnotations)):
            lhsRegion == rhsRegion && lhsAnnotations == rhsAnnotations
        case let (.selectedAnnotation(lhsModel), .selectedAnnotation(rhsModel)):
            lhsModel == rhsModel
        default:
            false
        }
    }
}

extension MKCoordinateRegion: @retroactive Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude
        && lhs.center.longitude == rhs.center.longitude
        && lhs.span.latitudeDelta == rhs.span.latitudeDelta
        && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}
