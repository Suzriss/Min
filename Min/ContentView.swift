import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
            Text("Min")
                .font(.title)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
