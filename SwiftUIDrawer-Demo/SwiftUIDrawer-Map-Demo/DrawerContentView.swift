import SwiftUI
import SwiftUIDrawer

struct DrawerContentView: View {
    let viewModel: ViewModel
    @Binding var drawerState: DrawerState

    var body: some View {
        switch viewModel.state {
        case let .overview(_, annotations):
            listView(with: annotations)
        case let .selectedAnnotation(annotation):
            cityDetails(for: annotation)
        }
    }

    private func listView(with annotations: [AnnotationModel]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select a city")
                .font(.largeTitle)
                .padding(.bottom, 8)

            ForEach(annotations) { annotation in
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
            drawerState.case = .partiallyOpened
        }
    }

    private func cityDetails(for annotation: AnnotationModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(annotation.name)
                .font(.largeTitle)

            AsyncImage(url: URL(string: annotation.imageAddress)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                } else if phase.error != nil {
                    Image(systemName: "photo.artframe")
                        .frame(width: 24, height: 24)
                        .frame(maxWidth: .infinity)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 250)

            Text(annotation.description)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

#Preview {
    @Previewable @State var drawerState = DrawerState(case: .fullyOpened)

    Color.green
        .drawerOverlay(
            state: $drawerState,
            content: {
                DrawerContentView(
                    viewModel: .init(
                        state: .selectedAnnotation(
                            MapData.annotations.first!
                        )
                    ), drawerState: $drawerState
                )
            }
        )
        .ignoresSafeArea()
}
