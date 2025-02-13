import MapKit

enum MapData {
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
    
    static let annotations: [AnnotationModel] = [
        .init(
            name: "Hamburg",
            description: "Hamburg, Germany's second-largest city, is known for its historic port, vibrant culture, and stunning architecture. It's a major hub for trade and industry with a rich maritime heritage.",
            region: Self.hamburgRegion
        ),
        .init(
            name: "Berlin",
            description: "Berlin, the capital of Germany, is a city steeped in history and culture. Known for its dynamic arts scene, iconic landmarks like the Brandenburg Gate, and a vibrant nightlife, Berlin is a city that never sleeps.",
            region: Self.berlinRegion
        ),
        .init(
            name: "Frankfurt",
            description: "Frankfurt is a global financial center, famous for its futuristic skyline and bustling airport. The city offers a blend of modernity and tradition, with historic sites and contemporary architecture.",
            region: Self.frankfurtRegion
        ),
        .init(
            name: "Munich",
            description: "Munich, the capital of Bavaria, is renowned for its Oktoberfest, beer gardens, and rich cultural heritage. It's a city of contrasts, combining historic architecture with modern urban living.",
            region: Self.munichRegion
        ),
        .init(
            name: "Stuttgart",
            description: "Stuttgart is the heart of Germany's automotive industry, home to companies like Mercedes-Benz and Porsche. It offers a mix of green spaces, vineyards, and a thriving cultural scene.",
            region: Self.stuttgartRegion
        ),
        .init(
            name: "Cologne",
            description: "Cologne is known for its impressive cathedral, lively carnival celebrations, and vibrant arts scene. Situated on the Rhine River, it’s a city with a rich history and a bustling urban vibe.",
            region: Self.cologneRegion
        ),
    ]
}
