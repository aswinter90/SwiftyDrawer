import SwiftUI
import SwiftUIDrawer
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var mapHeight: CGFloat = 0
    @State private var cameraPosition = MapCameraPosition.region(.init())
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    
    var body: some View {
        mapView
        .ignoresSafeArea()
        .readSize { mapHeight = $0.height }
        .onChange(of: mapHeight) {
            updateCameraPosition(
                with: mapHeight,
                currentRegion: viewModel.state.region
            )
        }
        .onChange(of: viewModel.state) { _, newState in
            updateCameraPosition(
                with: mapHeight,
                currentRegion: newState.region
            )
        }
        .drawerOverlay(
            state: $drawerState,
            midPosition: .absolute(450),
            isDimmingBackground: true,
            content: { DrawerContentView(viewModel: viewModel) }
        )
    }
    
    private var mapView: some View {
        Map(position: $cameraPosition) {
            ForEach(viewModel.annotations) { model in
                Annotation(model.name, coordinate: model.region.center) {
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
                                viewModel.didSelectAnnotation(model)
                            }
                        }
                }
            }
        }
    }
    
    private func updateCameraPosition(with mapHeight: CGFloat, currentRegion: MKCoordinateRegion) {
        var region = currentRegion
        
        let fraction = (mapHeight - drawerState.currentPosition) / mapHeight
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
