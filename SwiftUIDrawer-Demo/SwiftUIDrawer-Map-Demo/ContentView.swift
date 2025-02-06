import SwiftUI
import SwiftUIDrawer
import MapKit

struct ContentView: View {
    private static let hamburgCoordinate = CLLocationCoordinate2D(
        latitude: 53.552016,
        longitude: 9.994599
    )
    
    @State private var region = MKCoordinateRegion(
        center: hamburgCoordinate,
        span: MKCoordinateSpan(
            latitudeDelta: 0.025,
            longitudeDelta: 0.05
        )
    )
    
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    @State private var mapHeight: CGFloat = 0

    var body: some View {
        Map(position: .constant(.region(region))) {
            Annotation("Hamburg", coordinate: Self.hamburgCoordinate) {
                Text("📍")
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.yellow)
                    }
            }
        }
        .readSize { mapHeight = $0.height }
        .ignoresSafeArea()
        .onChange(of: mapHeight) {
            adjustMapCenter(with: mapHeight)
        }
        .drawerOverlay(
            state: $drawerState,
            content: {
                VStack {
                    Text("latitudeDelta: \(region.span.latitudeDelta)")
                    Text("drawer position: \(drawerState.currentPosition)")
                    Text("Screen height: \(UIScreen.main.bounds.height)")
                }
            }
        )
    }
    
    private func adjustMapCenter(with mapHeight: CGFloat) {
        let fraction = (mapHeight - drawerState.currentPosition) / mapHeight
        let offsetLatitude = region.span.latitudeDelta * fraction
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
