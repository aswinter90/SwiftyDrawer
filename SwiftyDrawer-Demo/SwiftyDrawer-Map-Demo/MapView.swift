import SwiftUI
import MapKit

struct MapView: View {
    @Binding var cameraPosition: MapCameraPosition
    let viewModel: ViewModel

    var body: some View {
        Map(position: $cameraPosition) {
            switch viewModel.state {
            case let .overview(_, annotations):
                ForEach(annotations) { annotation in
                    annotationView(for: annotation, isSelected: false)
                }
            case let .selectedAnnotation(annotation):
                annotationView(for: annotation, isSelected: true)
            }
        }
    }

    private func annotationView(for annotation: AnnotationModel, isSelected: Bool) -> Annotation<Text, some View> {
        Annotation(annotation.name, coordinate: annotation.region.center) {
            Image(systemName: isSelected ? "flag" : "building.2")
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
                .contentTransition(.symbolEffect)
        }
    }
}
