import Foundation

struct Lecture: Codable, Identifiable, Equatable {
    let id: UUID
    var courseName: String
    var lectureDate: Date
    var lectureTitle: String?
    var progressMinutes: Int = 0
    var totalMinutes: Int?
    var isCompleted: Bool = false
    let createdAt: Date

    init(
        id: UUID = UUID(),
        courseName: String,
        lectureDate: Date = Date(),
        lectureTitle: String? = nil,
        progressMinutes: Int = 0,
        totalMinutes: Int? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.courseName = courseName
        self.lectureDate = lectureDate
        self.lectureTitle = lectureTitle
        self.progressMinutes = progressMinutes
        self.totalMinutes = totalMinutes
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
