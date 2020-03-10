import Foundation

extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }

    var weekDay: Int? {
        return self.date?.weekDay
    }
}

extension Date {
    var weekDay: Int? {
        let components = Calendar.current.dateComponents([.weekday], from: self)
        return components.weekday
    }
}
