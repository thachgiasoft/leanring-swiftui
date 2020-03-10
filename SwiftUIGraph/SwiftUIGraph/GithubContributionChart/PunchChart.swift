import SwiftUI

struct PunchChart: View {

    @State var yearData: YearContributionData

    var contributions: [[DayContributionData]] {
        return yearData.formatContributions()
    }

    private func size(geometryProxy: GeometryProxy) -> CGSize {
        let width = (geometryProxy.size.width * 2 - 10) / CGFloat(self.contributions.count) - 2.0
        let height = width
        return CGSize(width: width, height: height)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 2.0) {
                        ForEach(self.contributions, id: \.self) { col in
                            ChartColumn(contributions: col, size: self.size(geometryProxy: geometry))
                        }
                    }.drawingGroup()
                }
            }
        }
    }
}
