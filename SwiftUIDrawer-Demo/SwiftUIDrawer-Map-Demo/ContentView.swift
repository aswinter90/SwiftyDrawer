import SwiftUI
import SwiftUIDrawer
import MapKit

struct ContentView: View {
    private static let drawerBottomPositionValue = 100.0
    private static let drawerMidPositionValue = 450.0
    
    @State private var viewModel = ViewModel()
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    @State private var mapHeight: CGFloat = 0
    @State private var cameraPosition = MapCameraPosition.region(.init())
    
    var body: some View {
        MapView(
            cameraPosition: $cameraPosition,
            viewModel: viewModel
        )
        .ignoresSafeArea()
        .onGeometryChange(
            for: CGFloat.self,
            of: { $0.size.height },
            action: {
                mapHeight = $0
                updateCameraPosition(
                    with: $0,
                    currentRegion: viewModel.state.region
                )
            }
        )
        .onChange(of: viewModel.state) { _, newState in
            updateCameraPosition(
                with: mapHeight,
                currentRegion: newState.region
            )
        }
        .drawerOverlay(
            state: $drawerState,
            bottomPosition: .constant(
                .relativeToSafeAreaBottom(offset: Self.drawerBottomPositionValue)
            ),
            midPosition: .absolute(Self.drawerMidPositionValue),
            isDimmingBackground: true,
            content: { DrawerContentView(viewModel: viewModel, drawerState: $drawerState) }
        )
        .drawerFloatingButtonsConfiguration(floatingButtonsConfiguration)
    }
    
    private var floatingButtonsConfiguration: DrawerFloatingButtonsConfiguration {
        guard case .selectedAnnotation = viewModel.state else {
            return .init()
        }
        
        return .init(
            leadingButtons: [
                .init(icon: .init(systemName: "arrow.backward")) {
                    viewModel.didReturn()
                }
            ]
        )
    }
    
    private func updateCameraPosition(with mapHeight: CGFloat, currentRegion: MKCoordinateRegion) {
        var region = currentRegion
        
        let fraction = (mapHeight - Self.drawerMidPositionValue) / mapHeight
        let offsetLatitude = region.span.latitudeDelta * fraction
        
        let newCenter = CLLocationCoordinate2D(
            latitude: region.center.latitude - offsetLatitude,
            longitude: region.center.longitude
        )
        
        region.center = newCenter
        
        withAnimation {
            cameraPosition = .region(region)
        }
    }
}

#Preview {
    ContentView()
}
