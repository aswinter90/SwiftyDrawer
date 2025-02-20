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

    // swiftlint:disable line_length
    static let annotations: [AnnotationModel] = [
        .init(
            name: "Hamburg",
            description: "Hamburg, Germany's second-largest city, is known for its historic port, vibrant culture, and stunning architecture. It's a major hub for trade and industry with a rich maritime heritage.",
            region: Self.hamburgRegion,
            imageAddress: "https://upload.wikimedia.org/wikipedia/commons/7/77/Rathaus_Hbg.jpg"
        ),
        .init(
            name: "Berlin",
            description: "Berlin, the capital of Germany, is a city steeped in history and culture. Known for its dynamic arts scene, iconic landmarks like the Brandenburg Gate, and a vibrant nightlife, Berlin is a city that never sleeps.",
            region: Self.berlinRegion,
            imageAddress: "https://upload.wikimedia.org/wikipedia/commons/f/f7/Museumsinsel_Berlin_Juli_2021_1_%28cropped%29_b.jpg"
        ),
        .init(
            name: "Frankfurt",
            description: "Frankfurt is a global financial center, famous for its futuristic skyline and bustling airport. The city offers a blend of modernity and tradition, with historic sites and contemporary architecture.",
            region: Self.frankfurtRegion,
            imageAddress: "https://upload.wikimedia.org/wikipedia/commons/e/e7/Frankfurter_Altstadt_mit_Skyline_2024_cropped.jpg"
        ),
        .init(
            name: "Munich",
            description: "Munich, the capital of Bavaria, is renowned for its Oktoberfest, beer gardens, and rich cultural heritage. It's a city of contrasts, combining historic architecture with modern urban living.",
            region: Self.munichRegion,
            imageAddress: "https://upload.wikimedia.org/wikipedia/commons/d/d3/Stadtbild_M%C3%BCnchen.jpg"
        ),
        .init(
            name: "Stuttgart",
            description: "Stuttgart is the heart of Germany's automotive industry, home to companies like Mercedes-Benz and Porsche. It offers a mix of green spaces, vineyards, and a thriving cultural scene.",
            region: Self.stuttgartRegion,
            imageAddress: "https://upload.wikimedia.org/wikipedia/commons/e/e1/Neues_Schloss_Schlossplatzspringbrunnen_Schlossplatz_Stuttgart_2015_01.jpg"
        ),
        .init(
            name: "Cologne",
            description: "Cologne is known for its impressive cathedral, lively carnival celebrations, and vibrant arts scene. Situated on the Rhine River, it’s a city with a rich history and a bustling urban vibe.",
            region: Self.cologneRegion,
            imageAddress: "https://upload.wikimedia.org/wikipedia/commons/f/fa/K%C3%B6lner_Dom_und_Hohenzollernbr%C3%BCcke_Abendd%C3%A4mmerung_%289706_7_8%29.jpg"
        )
    ]
    // swiftlint:enable line_length
}
