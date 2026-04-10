import Combine
import Foundation
import SwiftUI

class LectureStore: ObservableObject {
    private static let storageKey = "RecTracker.lectures"
    private static let coursesKey = "RecTracker.courses"

    @Published var allLectures: [Lecture] = [] {
        didSet { save() }
    }

    @Published var courses: [String] = [] {
        didSet { saveCourses() }
    }

    var pendingLectures: [Lecture] {
        allLectures
            .filter { !$0.isCompleted }
            .sorted { $0.lectureDate < $1.lectureDate }
    }

    var completedLectures: [Lecture] {
        allLectures
            .filter { $0.isCompleted }
            .sorted { $0.lectureDate > $1.lectureDate }
    }

    var groupedPendingLectures: [(String, [Lecture])] {
        grouped(pendingLectures)
    }

    var groupedCompletedLectures: [(String, [Lecture])] {
        grouped(completedLectures)
    }

    private func grouped(_ lectures: [Lecture]) -> [(String, [Lecture])] {
        let courseNames = Array(Set(lectures.map { $0.courseName })).sorted()
        return courseNames.map { course in
            (course, lectures.filter { $0.courseName == course })
        }
    }

    init() {
        load()
        loadCourses()
    }

    func add(_ lecture: Lecture) {
        allLectures.append(lecture)
    }

    func markAsCompleted(_ lecture: Lecture) {
        guard let index = allLectures.firstIndex(where: { $0.id == lecture.id }) else { return }
        allLectures[index].isCompleted = true
    }

    func updateProgress(_ lecture: Lecture, minutes: Int) {
        guard let index = allLectures.firstIndex(where: { $0.id == lecture.id }) else { return }
        allLectures[index].progressMinutes = minutes
    }

    func delete(_ lecture: Lecture) {
        allLectures.removeAll { $0.id == lecture.id }
    }

    func deleteAllCompleted() {
        allLectures.removeAll { $0.isCompleted }
    }

    func addCourse(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !courses.contains(trimmed) else { return }
        courses.append(trimmed)
        courses.sort()
    }

    func removeCourse(at offsets: IndexSet) {
        courses.remove(atOffsets: offsets)
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(allLectures) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let lectures = try? JSONDecoder().decode([Lecture].self, from: data) else { return }
        allLectures = lectures
    }

    private func saveCourses() {
        UserDefaults.standard.set(courses, forKey: Self.coursesKey)
    }

    private func loadCourses() {
        courses = UserDefaults.standard.stringArray(forKey: Self.coursesKey) ?? []
    }
}
