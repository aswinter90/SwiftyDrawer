import MapKit

enum Regions {
    private static let citySpan = MKCoordinateSpan(
        latitudeDelta: 0.035,
        longitudeDelta: 0.05
    )
    
    static let germanyRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 51.1642292,
            longitude: 10.4541194
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 11,
            longitudeDelta: 13
        )
    )
    
    static let hamburgRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 53.552016,
            longitude: 9.994599
        ),
        span: citySpan
    )
    
    static let berlinRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 52.52437,
            longitude: 13.41053
        ),
        span: citySpan
    )
    
    static let frankfurtRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 50.11552,
            longitude: 8.68417
        ),
        span: citySpan
    )
    
    static let munichRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 48.13743,
            longitude: 11.57549
        ),
        span: citySpan
    )
    
    static let stuttgartRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 48.78232,
            longitude: 9.17702
        ),
        span: citySpan
    )
    
    static let cologneRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 50.93333,
            longitude: 6.95
        ),
        span: citySpan
    )
}
