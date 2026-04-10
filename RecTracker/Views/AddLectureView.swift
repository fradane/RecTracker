import Combine
import SwiftUI

struct AddLectureView: View {
    @EnvironmentObject var store: LectureStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCourse = ""
    @State private var newCourseName = ""
    @State private var isAddingNewCourse = false
    @State private var lectureTitle = ""
    @State private var lectureDate = Date()
    @State private var totalMinutes: Int = 120

    private var effectiveCourseName: String {
        isAddingNewCourse || store.courses.isEmpty ? newCourseName : selectedCourse
    }

    private var canAdd: Bool {
        !effectiveCourseName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("New Lecture")
                .font(.headline)

            if store.courses.isEmpty {
                TextField("Course name", text: $newCourseName)
                    .textFieldStyle(.roundedBorder)
            } else {
                Picker("Course", selection: $selectedCourse) {
                    ForEach(store.courses, id: \.self) { course in
                        Text(course).tag(course)
                    }
                    Divider()
                    Text("New course...").tag("__new__")
                }
                .labelsHidden()
                .onChange(of: selectedCourse) { _, newValue in
                    isAddingNewCourse = (newValue == "__new__")
                    if isAddingNewCourse { newCourseName = "" }
                }

                if isAddingNewCourse {
                    TextField("Course name", text: $newCourseName)
                        .textFieldStyle(.roundedBorder)
                }
            }

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
                    let courseName = effectiveCourseName.trimmingCharacters(in: .whitespaces)
                    if isAddingNewCourse || store.courses.isEmpty {
                        store.addCourse(courseName)
                    }
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
                .disabled(!canAdd)
            }
        }
        .padding()
        .frame(width: 300)
        .onAppear {
            if let first = store.courses.first {
                selectedCourse = first
            }
        }
    }
}
