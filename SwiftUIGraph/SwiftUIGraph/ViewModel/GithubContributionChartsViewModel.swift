import Combine
import os.log

class GithubContributionChartsViewModel: ObservableObject {
    typealias FetchUserContributions = (String) -> AnyPublisher<[String: YearContributionData], Never>

    private let _fetchWithUsername = PassthroughSubject<String, Never>()
    private var cancellables: [AnyCancellable] = []

    @Published private(set) var allYearContributions: [YearContributionData] = []
    @Published private(set) var isLoading = false

    var username: String = ""

    init<S: Scheduler>(fetchUserContributions: @escaping FetchUserContributions = FetchGithubContributions.allYearData,
                       scheduler: S) {

        let fetchTrigger = _fetchWithUsername
            .filter { !$0.isEmpty }
            .debounce(for: .milliseconds(300), scheduler: scheduler)

        let response = fetchTrigger
            .receive(on: scheduler)
            .flatMap { username -> AnyPublisher<[String: YearContributionData], Never> in
                os_log("fetch trigger", log: .appDefault)
                return fetchUserContributions(username)
        }
        .eraseToAnyPublisher()

        response
            .map { $0.isEmpty }
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        response
            .map({ $0.sorted(by: { $0.key > $1.key }).map({ $0.value }) })
            .receive(on: scheduler)
            .assign(to: \.allYearContributions, on: self)
            .store(in: &cancellables)
    }

    func fetch() {
        print(#function)
        isLoading = true
        _fetchWithUsername.send(username)
    }
}
