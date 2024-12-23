# SwiftUIDrawer

A customizable drawer UI-component, which is mostly written in SwiftUI, that looks similar to the standard sheet modifier but comes with more fixed positions and further customization options.
Handy for showing expandable content on top of a background view like how Apple and Google do it in their map apps.

This project is still a WIP that I work on spontaneously. Later I might add more documentation and a license file to make it open-source.

## Examples

### Minimal setup

![image](https://github.com/user-attachments/assets/5c4c22e8-db86-4beb-9a44-ee43f2486d40)

```
struct MinimalContentView: View {
    @State private var drawerState = DrawerState.init(case: .partiallyOpened)
    
    var body: some View {
        AppleLogo()
            .padding(.top, 8)
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

### [With sticky header and changing alignments](https://github.com/aswinter90/SwiftUIDrawer/blob/main/SwiftUIDrawer-Demo/SwiftUIDrawer-Demo/ContentView.swift)

https://github.com/user-attachments/assets/efe3143f-4cc5-452a-a470-9c9f2c84034b
