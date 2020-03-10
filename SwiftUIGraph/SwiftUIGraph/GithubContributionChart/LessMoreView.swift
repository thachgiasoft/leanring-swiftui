import SwiftUI

struct LessMoreView: View {
    @EnvironmentObject var graphTheme: GraphTheme
    @State var size: CGSize

    var body: some View {
        HStack {
            Text("Less")
            ForEach(graphTheme.colors.intensities, id: \.self) { color in
                ChartCell(backgroundColor: color, size: self.size)
            }
            Text("More")
        }
    }
}

struct LessMoreView_Previews: PreviewProvider {
    static var previews: some View {
        LessMoreView(size: CGSize(width: 20, height: 20))
            .environmentObject(GraphTheme())
    }
}
