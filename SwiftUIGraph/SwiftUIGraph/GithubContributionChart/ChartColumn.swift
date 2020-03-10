import SwiftUI

struct ChartColumn: View {

    @EnvironmentObject var graphTheme: GraphTheme
    @State var contributions: [DayContributionData]
    @State var size: CGSize
    var spacing: CGFloat = 2.0

    private var formatedContributions: [DayContributionData] {
        if contributions.count == 7 {
            return contributions
        }
        let empties = (0..<(7-contributions.count)).map({ _ in DayContributionData.empty() })
        if contributions.first?.date.weekDay == 1 {
            return contributions + empties
        } else {
            return empties + contributions
        }
    }

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(formatedContributions, id: \.id) { contribution in
                ChartCell(backgroundColor: self.graphTheme.color(with: contribution.intensity), size: self.size)
            }
        }
    }
}

#if DEBUG
struct ChartColumn_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChartColumn(contributions: sampleDayContributions1, size: CGSize(width: 20, height: 20))
            ChartColumn(contributions: sampleDayContributions0, size: CGSize(width: 20, height: 20))
        }
    }
}

#endif

let sampleDayContributions1 = [
    DayContributionData(date: "2019-01-01", count: "0", color: "#ebedf0"),
    DayContributionData(date: "2019-01-02", count: "0", color: "#ebedf0"),
    DayContributionData(date: "2019-01-03", count: "4", color: "#c6e48b"),
    DayContributionData(date: "2019-01-04", count: "0", color: "#ebedf0"),
    DayContributionData(date: "2019-01-05", count: "3", color: "#c6e48b"),
]


let sampleDayContributions0 = [
    DayContributionData(date: "2019-12-29", count: "0", color: "#ebedf0"),
    DayContributionData(date: "2019-12-30", count: "0", color: "#ebedf0"),
    DayContributionData(date: "2019-12-31", count: "0", color: "#ebedf0")
]
