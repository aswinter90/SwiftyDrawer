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
    
    @Published var state: State
    let annotations: [AnnotationModel] = [
        .init(name: "Hamburg", region: Regions.hamburgRegion),
        .init(name: "Berlin", region: Regions.berlinRegion),
        .init(name: "Frankfurt", region: Regions.frankfurtRegion),
        .init(name: "Munich", region: Regions.munichRegion),
        .init(name: "Stuttgart", region: Regions.stuttgartRegion),
        .init(name: "Cologne", region: Regions.cologneRegion),
    ]
    
    init(state: State = .overview(region: Regions.germanyRegion)) {
        self.state = state
    }
    
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
