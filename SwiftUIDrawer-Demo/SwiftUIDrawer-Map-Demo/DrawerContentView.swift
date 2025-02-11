import SwiftUI
import SwiftUIDrawer

struct DrawerContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        switch viewModel.state {
        case .overview:
            listView
        case let .selectedAnnotation(annotation):
            cityDetails(for: annotation)
        }
    }
    
    private var listView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select a city")
                .font(.largeTitle)
                .padding(.bottom, 8)
            
            ForEach(viewModel.annotations) { annotation in
                listItem(for: annotation)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
    
    private func listItem(for annotation: AnnotationModel) -> some View {
        VStack(spacing: 16) {
            Text(annotation.name)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            Divider()
                .frame(height: 1)
        }
        .overlay(alignment: .trailing) {
            Image(systemName: "chevron.right")
        }
        .background()
        .onTapGesture {
            viewModel.didSelectAnnotation(annotation)
        }
    }
    
    private func cityDetails(for model: AnnotationModel) -> some View {
        VStack {
            Text(model.name)
                .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

#Preview {
    @Previewable @State var state = DrawerState(case: .fullyOpened)
    
    Color.green
        .drawerOverlay(
            state: $state,
            content: {
                DrawerContentView(
                    viewModel: .init(
                        state: .selectedAnnotation(
                            .init(
                                name: "Hamburg",
                                region: Regions.hamburgRegion
                            )
                        )
                    )
                )
            }
        )
        .ignoresSafeArea()
}
