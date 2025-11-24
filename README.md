# SwiftyDrawer

<img src="https://github.com/user-attachments/assets/a439db3d-2bbe-4c81-aaa0-7308832dd5ce" width=400p>


This mostly SwiftUI-based customizable drawer component offers functionality similar to the standard sheet modifier, but with additional fixed positions and extensive customization options. Ideal for displaying expandable and scrollable content on top of a background view, akin to the drawer behavior seen in Apple's and Google's map applications.

This project is currently a work in progress, being developed sporadically. Future updates may include additional documentation and bug fixes.

## 🔩 Installation
You can add SwiftyDrawer to an Xcode project by adding it as a package dependency. The required minimum platform version is iOS 15.

From the File menu, select Add Package Dependencies...
Enter "https://github.com/aswinter90/SwiftyDrawer" into the package repository URL text field.

Or add it to your Swift package by referencing it in your package manifest:

```
let package = Package(
    name: "MyLibrary",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MyLibrary",
            targets: ["MyLibrary"]),

    ],
    dependencies: [
        .package(url: "https://github.com/aswinter90/SwiftyDrawer", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MyLibrary",
            dependencies: ["SwiftyDrawer"]
        ),
    ]
)
```

## 📱 Examples

The project contains multiple demo applications with showcases for displaying the `SwiftyDrawer` in different usage scenarios.

### Minimal setup

<img width="350" height="761" alt="image" src="https://github.com/user-attachments/assets/b192581e-9a37-41d3-9898-7ccf1f99b9ed" />

```
import SwiftUI
import SwiftyDrawer

struct ContentView: View {
    @State private var drawerState = DrawerState(case: .partiallyOpened)

    var body: some View {
        MySwiftLogo()
            .drawerOverlay(
                state: $drawerState,
                content: {
                    VStack {
                        ForEach(0..<30) { index in
                            Text("Item \(index)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()

                            Divider()
                        }
                    }
                    .padding(.top, 8)
                }
            )
    }
}
```

### [With sticky header and changing alignments](https://github.com/aswinter90/SwiftyDrawer/blob/main/SwiftyDrawer-Demo/SwiftyDrawer-Advanced-Demo/ContentView.swift)

As shown in the video the drawer can be modified with a sticky header, which stays on top of the safe area or the tab bar when the drawer is closed. The default drag handle can also be replaced with any other given view.
Finally the `DrawerState` is mutable and changing it from the outside will update the drawer position automatically.

https://github.com/user-attachments/assets/107b48e3-2f99-47ac-a7a9-5430d77b444a

### [State based drawer content](https://github.com/aswinter90/SwiftyDrawer/blob/main/SwiftyDrawer-Demo/SwiftyDrawer-Map-Demo/ContentView.swift)

This is a demonstration for how the drawer content can be updated by observing a ViewModel state.

https://github.com/user-attachments/assets/0b127664-3b4d-40a6-8a0a-98061e0b6680

## Customization

There are several modifiers for changing the drawer appearance and behaviors:

```
MySwiftLogo()
    .drawerOverlay(
        state: $drawerState,
        content: {...}
    )
    .drawerStyle(drawerStyle: DrawerStyle)
    .drawerFloatingButtonsConfiguration(configuration: DrawerFloatingButtonsConfiguration)
    .drawerLayoutStrategy(layoutStrategy: DrawerContentLayoutStrategy)
    .drawerAnimation(<animation: Animation)
    .isDrawerHapticFeedbackEnabled(isEnabled: Bool)
    .isApplyingRenderingOptimizationToDrawerHeader(Bool)
    .drawerContentOffsetController(DrawerContentOffsetController?)
    .drawerOriginObservable(DrawerOriginObservable?)
```

## 💥 Known issues
- Bugs and glitches on older iOS versions like 15 must be expected. In some scenarios the drawer content is not scrollable in other the content's scroll level resets randomnly.
- The drawer always requires a modifyable `state` binding, meaning that passing a constant binding will not work: `.drawerOverlay(state: Binding.constant(.init(case: .fullyOpened)), ...)`
- Your content gets updated but it is not reflected in the drawer? Make sure to define your content as a dedicated view, which obsorves changes of a `Binding` or an `ObservableObject` or take a look at the `SwiftyDrawer-Map-Demo`.
