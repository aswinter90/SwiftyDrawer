import SwiftUI
import SwiftUIDrawer
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 53.552016,
            longitude: 9.994599
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    private let hamburgCoordinate = CLLocationCoordinate2D(
        latitude: 53.552016,
        longitude: 9.994599
    )

    var body: some View {
        Map(position: .constant(.region(region))) {
            Annotation("Hamburg", coordinate: hamburgCoordinate) {
                Text("📍")
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.yellow)
                    }
            }
        }
        .onAppear {
            adjustMapCenter()
        }
        .drawerOverlay(
            state: $drawerState,
            content: { Text("Hello") }
        )
    }
    
    private func adjustMapCenter() {
        let offsetLatitude = region.span.latitudeDelta * 0.5 // Adjust this value to move the coordinate to the upper half
        let newCenter = CLLocationCoordinate2D(
            latitude: region.center.latitude - offsetLatitude,
            longitude: region.center.longitude
        )
        region.center = newCenter
    }
}

struct ContentView2: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: .constant(.region(region)))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    adjustMapCenter()
                }
            
            VStack {
                Text("Other view covering lower half")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: UIScreen.main.bounds.height / 2)
            .background(Color.black.opacity(0.7))
        }
    }

    private func adjustMapCenter() {
        let offsetLatitude = region.span.latitudeDelta * 0.5 // Adjust this value to move the coordinate to the upper half
        let newCenter = CLLocationCoordinate2D(
            latitude: region.center.latitude - offsetLatitude,
            longitude: region.center.longitude
        )
        region.center = newCenter
    }
}

#Preview {
    ContentView()
}
