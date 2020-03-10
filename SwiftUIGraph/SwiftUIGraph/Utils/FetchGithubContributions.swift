import Foundation
import SwiftSoup
import Combine
import os.log

public struct YearContributionData {
    let year: String
    let total: Int
    let range: (start: String, end: String)
    let contributions: [DayContributionData]

    func formatContributions() -> [[DayContributionData]] {
        var ret = [[DayContributionData]]()

        let firsts = Array(contributions.prefix(upTo: 8 - (contributions.first?.date.weekDay ?? 0)))
        ret.append(firsts)
        let yearDataContributions = Array(contributions.dropFirst(firsts.count))

        let count = yearDataContributions.count
        let weekCount = count / 7

        for index in 0...weekCount {
            let start = index * 7
            let end = min(start + 7, yearDataContributions.count)
            ret.append(Array(yearDataContributions[start..<end]))
        }
        return ret
    }
}

let colorMap = [
  "#196127": 4,
  "#239a3b": 3,
  "#7bc96f": 2,
  "#c6e48b": 1,
  "#ebedf0": 0
]

public struct DayContributionData: Identifiable, Hashable {
    public let id: UUID = UUID()
    public let date: String
    public let count: String
    public let color: String
    public var intensity: Int {
        return colorMap[color] ?? 0
    }

    static func empty() -> DayContributionData {
        return DayContributionData(date: "", count: "0", color: "#ffffff")
    }
}

public struct FetchGithubContributions {

    func fetchYears(username: String) -> [(href: String, year: String)] {
        do {
            let html = try String(contentsOf: URL(string: "https://github.com/\(username)")!, encoding: .ascii)
            let doc: Document = try SwiftSoup.parse(html)
            let elements = try doc.select(".js-year-link")

            os_log(#function, log: .appDefault)
//            let elem = elements[0]
//            let href = try elem.attr("href")
//            let year = try elem.text()
//            return [(href, year)]
            return try elements.map { element -> (String, String) in
                let href = try element.attr("href")
                let year = try element.text()
                return (href, year)
            }
        } catch {
            return []
        }
    }

    func fetchDataForYear(url: String, year: String) -> YearContributionData? {
        do {
            let html = try String(contentsOf: URL(string: "https://github.com\(url)")!, encoding: .ascii)
            let doc: Document = try SwiftSoup.parse(html)

            let days = try doc.select("rect.day")

            let contributeText = try doc.select(".js-yearly-contributions h2")
                .text()
                .trimmingCharacters(in: .whitespacesAndNewlines)

            let contributionCount = Int(contributeText.components(separatedBy: CharacterSet.decimalDigits.inverted).first ?? "0")!
            let startDate: String = try days.first()?.attr("data-date") ?? ""
            let endDate: String = try days.last()?.attr("data-date") ?? ""
            let contributions = try days.map { day in
                return DayContributionData(date: try day.attr("data-date"),
                                           count: try day.attr("data-count"),
                                           color: try day.attr("fill"))
            }

            os_log(#function, log: .appDefault)
            return YearContributionData(year: year,
                                        total: contributionCount,
                                        range: (startDate, endDate),
                                        contributions: contributions)
        } catch {
            return nil
        }
    }

    /// Sync
    public func fetchDataForAllYear(username: String) -> [String: YearContributionData] {
        return fetchYears(username: username)
            .reduce(into: [String: YearContributionData]()) { result, urlAndYear in
                result[urlAndYear.year] = fetchDataForYear(url: urlAndYear.href, year: urlAndYear.year)
        }
    }

    /// Async
    public func fetchDataForAllYear(username: String, completion: @escaping (([String: YearContributionData]) -> Void)) {
        DispatchQueue.global().async {

            if let (url, year) = self.fetchYears(username: username).first, let firstResult = self.fetchDataForYear(url: url, year: year) {
                os_log(#function, log: .appDefault)
                completion([year: firstResult])
            } else {
                completion([:])
            }
//            let result = self.fetchYears(username: username)
//                .reduce(into: [String: YearContributionData]()) { result, urlAndYear in
//                    result[urlAndYear.year] = self.fetchDataForYear(url: urlAndYear.href, year: urlAndYear.year)
//            }
//            completion(result)
        }
    }

    public typealias FetchResponse = AnyPublisher<[String: YearContributionData], Never>

    static let fetchContributions = FetchGithubContributions()

    public static func allYearData(username: String) -> FetchResponse {
        return Future<[String: YearContributionData], Never> { promise in
            fetchContributions.fetchDataForAllYear(username: username) { allYearData in
                DispatchQueue.main.async {
                    return promise(.success(allYearData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
