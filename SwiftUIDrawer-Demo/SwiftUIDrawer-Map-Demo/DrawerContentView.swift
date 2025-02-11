import SwiftUI
import SwiftUIDrawer

struct DrawerContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        switch viewModel.state {
        case .overview:
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
        case .selectedAnnotation(let annotation):
            VStack {
                Text(annotation.name)
                    .font(.largeTitle)
            }
        }
    }
    
    private func listItem(for annotation: ViewModel.AnnotationModel) -> some View {
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
}

#Preview {
    @Previewable @State var state = DrawerState(case: .fullyOpened)
    
    Color.green
        .drawerOverlay(
            state: $state,
            content: {
                DrawerContentView(viewModel: .init())
            }
        )
        .ignoresSafeArea()
}
