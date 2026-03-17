import Combine
import SwiftUI

struct AddLectureView: View {
    @EnvironmentObject var store: LectureStore
    @Environment(\.dismiss) private var dismiss

    @State private var courseName = ""
    @State private var lectureTitle = ""
    @State private var lectureDate = Date()
    @State private var totalMinutes: Int = 90

    var body: some View {
        VStack(spacing: 12) {
            Text("New Lecture")
                .font(.headline)

            TextField("Course name", text: $courseName)
                .textFieldStyle(.roundedBorder)

            TextField("Lecture title (optional)", text: $lectureTitle)
                .textFieldStyle(.roundedBorder)

            DatePicker("Date", selection: $lectureDate, displayedComponents: .date)

            Stepper("Duration: \(TimeFormatter.format(minutes: totalMinutes))", value: $totalMinutes, in: 5...600, step: 5)

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Button("Add") {
                    let lecture = Lecture(
                        courseName: courseName,
                        lectureDate: lectureDate,
                        lectureTitle: lectureTitle.isEmpty ? nil : lectureTitle,
                        totalMinutes: totalMinutes
                    )
                    store.add(lecture)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(courseName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding()
        .frame(width: 300)
    }
}
