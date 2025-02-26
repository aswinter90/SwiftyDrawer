# SwiftyDrawer

This mostly SwiftUI-based customizable drawer component offers functionality similar to the standard sheet modifier, but with additional fixed positions and extensive customization options. Ideal for displaying expandable and scrollable content over a background view, akin to the drawer behavior seen in Apple and Google map applications.

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
        .package(url: "https://github.com/aswinter90/SwiftyDrawer", from: "0.1.0")
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

https://github.com/user-attachments/assets/daf244f4-a09f-4272-9095-8aa4669a4b26

### [State based drawer content](https://github.com/aswinter90/SwiftyDrawer/blob/main/SwiftyDrawer-Demo/SwiftyDrawer-Map-Demo/ContentView.swift)

This is a demonstration for how the drawer content can be updated by observing a ViewModel state.

https://github.com/user-attachments/assets/0b127664-3b4d-40a6-8a0a-98061e0b6680
