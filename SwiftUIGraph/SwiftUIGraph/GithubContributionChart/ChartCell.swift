import SwiftUI

struct ChartCell: View {
    var backgroundColor: Color
    var size: CGSize

    var body: some View {
        ZStack {
            Rectangle().fill(backgroundColor)
        }
        .frame(width: self.size.width, height: self.size.height)
        .shadow(radius: 0.2)
    }
}

struct GithubContributionChartCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Divider()
            HStack {
                ForEach(Standard().intensities, id: \.self) { intensity in
                    ChartCell(backgroundColor: intensity, size: CGSize(width: 20, height: 20))
                }
            }
            Divider()
            HStack {
                ForEach(Standard().intensities, id: \.self) { intensity in
                    ChartCell(backgroundColor: intensity, size: CGSize(width: 20, height: 20))
                }
            }
            Divider()
        }
    }
}
