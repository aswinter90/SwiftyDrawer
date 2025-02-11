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
        .onAppear { cameraPosition = .region(viewModel.state.region) }
        .readSize { mapHeight = $0.height }
        .onChange(of: mapHeight) {
            adjustMapCenter(
                with: mapHeight,
                currentRegion: viewModel.state.region
            )
        }
        .onChange(of: viewModel.state, { _, newState in
            withAnimation {
                let region = newState.region
                cameraPosition = .region(region)
                adjustMapCenter(with: mapHeight, currentRegion: region)
            }
        })
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
                Annotation(model.name, coordinate: model.region.center, anchor: .bottom) {
                    Image(systemName: "building")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 1)
                        .padding(.vertical, 3)
                        .background {
                            RoundedRectangle(cornerRadius: 2)
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
    
    private func adjustMapCenter(with mapHeight: CGFloat, currentRegion: MKCoordinateRegion) {
        var region = currentRegion
        
        let fraction = (mapHeight - drawerState.currentPosition) / mapHeight
        let offsetLatitude = region.span.latitudeDelta * fraction
        
        let newCenter = CLLocationCoordinate2D(
            latitude: region.center.latitude - offsetLatitude,
            longitude: region.center.longitude
        )
        
        region.center = newCenter
        cameraPosition = .region(region)
    }
}

#Preview {
    ContentView()
}
