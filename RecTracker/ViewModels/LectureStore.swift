import Combine
import Foundation

class LectureStore: ObservableObject {
    private static let storageKey = "RecTracker.lectures"

    @Published var allLectures: [Lecture] = [] {
        didSet { save() }
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

    init() {
        load()
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

    private func save() {
        guard let data = try? JSONEncoder().encode(allLectures) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let lectures = try? JSONDecoder().decode([Lecture].self, from: data) else { return }
        allLectures = lectures
    }
}
