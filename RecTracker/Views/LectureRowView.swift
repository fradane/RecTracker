import Combine
import SwiftUI

struct LectureRowView: View {
    let lecture: Lecture
    @EnvironmentObject var store: LectureStore
    @State private var showPopover = false
    @State private var editedMinutes: Double = 0

    private var maxMinutes: Double {
        Double(lecture.totalMinutes ?? 600)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(lecture.courseName)
                    .fontWeight(.bold)
                HStack(spacing: 4) {
                    Text(lecture.lectureDate, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if let title = lecture.lectureTitle, !title.isEmpty {
                        Text("— \(title)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                if lecture.progressMinutes > 0 {
                    Text("Resume from \(TimeFormatter.format(minutes: lecture.progressMinutes))")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            Spacer()
            if lecture.isCompleted {
                Button {
                    store.delete(lecture)
                } label: {
                    Image(systemName: "trash.circle")
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    store.markAsCompleted(lecture)
                } label: {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(.green)
                }
                .buttonStyle(.plain)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !lecture.isCompleted {
                editedMinutes = Double(lecture.progressMinutes)
                showPopover = true
            }
        }
        .popover(isPresented: $showPopover, arrowEdge: .trailing) {
            VStack(spacing: 12) {
                Text("Progress")
                    .font(.headline)

                HStack {
                    Slider(value: $editedMinutes, in: 0...maxMinutes, step: 5)
                    Text(TimeFormatter.format(minutes: Int(editedMinutes)))
                        .monospacedDigit()
                        .frame(width: 50, alignment: .trailing)
                }

                HStack {
                    Button(role: .destructive) {
                        store.delete(lecture)
                        showPopover = false
                    } label: {
                        Text("Delete")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)

                    Button {
                        store.updateProgress(lecture, minutes: Int(editedMinutes))
                        showPopover = false
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(width: 260)
        }
    }
}
