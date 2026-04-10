import Combine
import SwiftUI

struct MenuContentView: View {
    @StateObject private var store = LectureStore()
    @State private var showAddSheet = false
    @State private var showCompleted = false
    @State private var showManageCourses = false
    @State private var showDeleteCompletedConfirm = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("RecTracker")
                    .font(.headline)
                Spacer()
                Button {
                    showManageCourses = true
                } label: {
                    Image(systemName: "books.vertical")
                }
                .buttonStyle(.plain)
                .padding(.trailing, 6)
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            // Lecture list
            let groups = showCompleted ? store.groupedCompletedLectures : store.groupedPendingLectures
            if groups.isEmpty {
                VStack(spacing: 8) {
                    Spacer()
                    Text(showCompleted ? "No completed lectures" : "All caught up, good job!")
                        .foregroundStyle(.secondary)
                        .font(.callout)
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            } else {
                List {
                    ForEach(groups, id: \.0) { courseName, lectures in
                        Section(header: Text(courseName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        ) {
                            ForEach(lectures) { lecture in
                                LectureRowView(lecture: lecture)
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }

            Divider()

            // Footer
            HStack {
                let count = store.pendingLectures.count
                Text("\(count) pending")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Toggle("Completed", isOn: $showCompleted)
                    .toggleStyle(.checkbox)
                    .font(.caption)
                Spacer()
                Button {
                    showDeleteCompletedConfirm = true
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.red)
                .font(.caption)
                .opacity(showCompleted && !store.completedLectures.isEmpty ? 1 : 0)
                .disabled(!(showCompleted && !store.completedLectures.isEmpty))
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(width: 320, height: 450)
        .sheet(isPresented: $showAddSheet) {
            AddLectureView()
        }
        .sheet(isPresented: $showManageCourses) {
            ManageCoursesView()
        }
        .confirmationDialog("Delete all completed recordings?", isPresented: $showDeleteCompletedConfirm, titleVisibility: .visible) {
            Button("Delete All", role: .destructive) {
                store.deleteAllCompleted()
            }
        }
        .environmentObject(store)
    }
}
