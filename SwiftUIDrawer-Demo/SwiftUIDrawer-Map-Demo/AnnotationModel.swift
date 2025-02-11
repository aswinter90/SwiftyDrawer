import MapKit

struct AnnotationModel: Equatable, Identifiable {
    var id = UUID().uuidString
    let name: String
    let region: MKCoordinateRegion
}
