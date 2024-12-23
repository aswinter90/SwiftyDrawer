# SwiftUIDrawer

A customizable drawer UI-component, which is mostly written in SwiftUI, that looks similar to the standard sheet modifier but comes with more fixed positions and further customization options.
Handy for showing expandable content on top of a background view like how Apple and Google do it in their map apps.

This project is still a WIP that I work on spontaneously. Later I might add more documentation and a license file to make it open-source.

## Examples

### Minimal setup

![image](https://github.com/user-attachments/assets/36863d01-7fdb-4a86-8e98-daa8719337d1)

```
struct MinimalContentView: View {
    @State private var drawerState = DrawerState.init(case: .partiallyOpened)
    
    var body: some View {
        AppleLogo()
            .drawerOverlay(
                state: $drawerState,
                content: {
                    VStack(spacing: 16) {
                        ForEach(0..<30) { index in
                            Text("Item \(index)")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.top, 8)
                }
            )
    }
}
```

### With sticky header and changing alignments

https://github.com/user-attachments/assets/a20808c2-e293-4603-aaee-2699c418307a
