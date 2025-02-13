import SwiftUI
import SwiftUIDrawer
import MapKit

struct ContentView: View {
    private static let drawerBottomPositionValue = 100.0
    private static let drawerMidPositionValue = 450.0
    
    @StateObject private var viewModel = ViewModel()
    @State private var mapHeight: CGFloat = 0
    @State private var cameraPosition = MapCameraPosition.region(.init())
    
    var body: some View {
        mapView
        .ignoresSafeArea()
        .onGeometryChange(
            for: CGFloat.self, of: {
                $0.size.height
            }, action: {
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
            state: $viewModel.drawerState,
            bottomPosition: .constant(.relativeToSafeAreaBottom(offset: Self.drawerBottomPositionValue)),
            midPosition: .absolute(Self.drawerMidPositionValue),
            isDimmingBackground: true,
            content: { DrawerContentView(viewModel: viewModel) }
        )
    }
    
    private var mapView: some View {
        Map(position: $cameraPosition) {
            switch viewModel.state {
            case let .overview(_, annotations):
                ForEach(annotations) { annotation in
                    annotationView(for: annotation)
                }
            case let .selectedAnnotation(annotation):
                annotationView(for: annotation)
            }
        }
    }
    
    private func annotationView(for annotation: AnnotationModel) -> Annotation<Text, some View> {
        Annotation(annotation.name, coordinate: annotation.region.center) {
            Image(systemName: "building")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(.blue)
                .padding(.vertical, 6)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(.white)
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.didSelectAnnotation(annotation)
                    }
                }
        }
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
