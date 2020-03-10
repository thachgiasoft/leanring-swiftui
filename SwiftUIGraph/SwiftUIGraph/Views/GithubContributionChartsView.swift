import SwiftUI

struct GithubContributionChartsView: View {

    @State var graphTheme: GraphTheme = GraphTheme()
    @ObservedObject var viewModel: GithubContributionChartsViewModel

    @State private var favoriteColor = 0

    var body: some View {
        NavigationView {
            VStack {

                HStack {
                    HStack {
                        TextField("Enter username...", text: $viewModel.username) {
                            self.viewModel.fetch()
                        }
                        .padding([.leading, .trailing], 10)
                        .foregroundColor(.primary)
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    Button(action: {
                        self.viewModel.fetch()
                        self.endEditing(true)
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                    }
                    .padding(5)
                    .cornerRadius(8)
                    .disabled(viewModel.isLoading)
                }
                .padding([.leading, .trailing], 10)

                Picker(selection: $graphTheme.selectedIndex, label: Text("Select Theme?")) {
                    Text("🍀 Standard").tag(0)
                    Text("🎃 Halloween").tag(1)
                    Text("🦋 Teal").tag(2)
//                    Text("🏴 Leftpad").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())

                LessMoreView(size: CGSize(width: 10, height: 10))
                    .environmentObject(graphTheme)

                List {
                    if viewModel.isLoading {
                        Text("Loading...")
                    } else {
                        ForEach(viewModel.allYearContributions, id: \.year) { (yearData: YearContributionData)  in
                            VStack {
                                Text("### \(yearData.year) ###").padding()
                                PunchChart(yearData: yearData).frame(height: 100)
                                    .environmentObject(self.graphTheme)
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("Search 🔍"))
            }
        }
    }
}

struct GithubContributionChartsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GithubContributionChartsView(viewModel: GithubContributionChartsViewModel(scheduler: DispatchQueue.main))
        }
    }
}

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows
            .filter{ $0.isKeyWindow }
            .forEach { $0.endEditing(true) }
    }
}
