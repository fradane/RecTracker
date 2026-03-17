import Combine
import SwiftUI

struct MenuContentView: View {
    @StateObject private var store = LectureStore()
    @State private var showAddSheet = false
    @State private var showCompleted = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("RecTracker")
                    .font(.headline)
                Spacer()
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
            let lectures = showCompleted ? store.completedLectures : store.pendingLectures
            if lectures.isEmpty {
                VStack(spacing: 8) {
                    Spacer()
                    Text(showCompleted ? "No completed lectures" : "All caught up, good job!")
                        .foregroundStyle(.secondary)
                        .font(.callout)
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            } else {
                List(lectures) { lecture in
                    LectureRowView(lecture: lecture)
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
        .environmentObject(store)
    }
}
