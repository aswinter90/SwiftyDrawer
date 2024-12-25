import SwiftUI

public struct DragHandle: View {
    public init() {}
    
    public var body: some View {
        HStack {
            Color.border
                .frame(width: 32, height: 4)
                .cornerRadius(2.0)
        }
        .frame(height: DrawerConstants.dragHandleHeight)
        .frame(maxWidth: .infinity)
    }
}
