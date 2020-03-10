import SwiftUI

struct PunchChartContainer: View {
    @State var yearData: YearContributionData
    @State var isDetailOpened: Bool = false

    var body: some View {
        VStack {
            if isDetailOpened {
                PunchChart(yearData: yearData).frame(height: 100)
            } else {
                Button(action: {
                    self.isDetailOpened = !self.isDetailOpened
                }) {
                    Text("Show Chart").foregroundColor(.primary)
                }
            }
        }
    }
}

let sampleYearContributionData = YearContributionData(year: "2019",
                                  total: 0,
                                  range: (start: "2019-01-01", end: "2019-12-31"),
                                  contributions: [])

struct PunchChartContainer_Previews: PreviewProvider {
    static var previews: some View {
        PunchChartContainer(yearData: sampleYearContributionData)
    }
}
