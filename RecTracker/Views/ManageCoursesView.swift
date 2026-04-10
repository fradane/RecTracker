import SwiftUI

struct ManageCoursesView: View {
    @EnvironmentObject var store: LectureStore
    @Environment(\.dismiss) private var dismiss
    @State private var newCourseName = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Manage Courses")
                    .font(.headline)
                Spacer()
                Button("Done") { dismiss() }
            }
            .padding()

            Divider()

            if store.courses.isEmpty {
                Spacer()
                Text("No courses yet")
                    .foregroundStyle(.secondary)
                    .font(.callout)
                Spacer()
            } else {
                List {
                    ForEach(store.courses, id: \.self) { course in
                        Text(course)
                    }
                    .onDelete { offsets in
                        store.removeCourse(at: offsets)
                    }
                }
                .listStyle(.inset)
            }

            Divider()

            HStack {
                TextField("New course name", text: $newCourseName)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { addCourse() }
                Button("Add") { addCourse() }
                    .disabled(newCourseName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
        }
        .frame(width: 280, height: 350)
    }

    private func addCourse() {
        store.addCourse(newCourseName)
        newCourseName = ""
    }
}
