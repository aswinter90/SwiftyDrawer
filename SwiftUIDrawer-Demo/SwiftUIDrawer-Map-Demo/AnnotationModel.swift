import MapKit

struct AnnotationModel: Equatable, Identifiable {
    var id = UUID().uuidString
    let name: String
    let description: String
    let region: MKCoordinateRegion
}
