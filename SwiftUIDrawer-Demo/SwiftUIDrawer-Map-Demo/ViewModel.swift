import Foundation
import MapKit
import SwiftUIDrawer

class ViewModel: ObservableObject {
    enum State {
        case overview(region: MKCoordinateRegion)
        case selectedAnnotation(_ annotation: AnnotationModel)
        
        var region: MKCoordinateRegion {
            switch self {
            case .overview(let region):
                region
            case .selectedAnnotation(let model):
                model.region
            }
        }
    }
    
    struct AnnotationModel: Equatable {
        let name: String
        let region: MKCoordinateRegion
    }
    
    private static let germanyRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 51.1642292,
            longitude: 10.4541194
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0,
            longitudeDelta: 10
        )
    )
    
    private static let hamburgRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 53.552016,
            longitude: 9.994599
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.025,
            longitudeDelta: 0.05
        )
    )
    
    @Published var state: State = .overview(region: germanyRegion)
    let annotations = [AnnotationModel(name: "Hamburg", region: hamburgRegion)]
    
    func didSelectAnnotation(_ annotation: AnnotationModel) {
        state = .selectedAnnotation(annotation)
    }
}

extension ViewModel.State: Equatable {
    static func ==(lhs: ViewModel.State, rhs: ViewModel.State) -> Bool {
        return switch (lhs, rhs) {
        case let (.overview(lhsRegion), .overview(rhsRegion)):
            lhsRegion == rhsRegion
        case let (.selectedAnnotation(lhsModel), .selectedAnnotation(rhsModel)):
            lhsModel == rhsModel
        default:
            false
        }
    }
}
 
extension MKCoordinateRegion: @retroactive Equatable {
    public static func ==(lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude
        && lhs.center.longitude == rhs.center.longitude
        && lhs.span.latitudeDelta == rhs.span.latitudeDelta
        && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}
