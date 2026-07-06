import SwiftUI

/// A view that records and displays its lifecycle events.
struct LifecycleMonitor: View {
	var label: String
	var recordEntry: (TimelineEntry) -> Void = { _ in }

	@State private var stateCreatedEntry: TimelineEntry? = nil
	@State private var taskStartedEntry: TimelineEntry? = nil
	@State private var onAppearEntry: TimelineEntry? = nil
	@State private var onDisappearEntry: TimelineEntry? = nil
	@State private var color: Color = LifecycleMonitorColors.next()

	var body: some View {
		VStack(spacing: 16) {
			Text(self.label)
				.font(.title3)
			Grid(horizontalSpacing: 16) {
				GridRow(alignment: .firstTextBaseline) {
					Text("@State")
						.gridColumnAlignment(.leading)
					TimelineEntryAge(entry: self.stateCreatedEntry, style: .relative)
						.gridColumnAlignment(.leading)
				}
				.help("When the state (incl. @State and @StateObject) for this view was created")

				GridRow(alignment: .firstTextBaseline) {
					Text("task")
					TimelineEntryAge(entry: self.taskStartedEntry, style: .relative)
				}
				.help("When task was last called for this view")

				GridRow(alignment: .firstTextBaseline) {
					Text("onAppear")
					TimelineEntryAge(entry: self.onAppearEntry, style: .relative)
				}
				.help("When onAppear was last called for this view")

				GridRow(alignment: .firstTextBaseline) {
					Text("onDisappear")
					TimelineEntryAge(entry: self.onDisappearEntry, style: .relative)
				}
				.help("When onDisappear was last called for this view")
			}
			.font(.callout)
		}
		.padding()
		.frame(maxWidth: .infinity)
		.background {
			RoundedRectangle(cornerRadius: 16)
				.fill(self.color.opacity(0.18))
				.overlay {
					RoundedRectangle(cornerRadius: 16)
						.stroke(self.color.opacity(0.35))
				}
		}
		.task {
			self.recordStateCreatedEntryIfNeeded()
			let entry = self.record(.taskStarted(self.label))
			let animation: Animation? = self.taskStartedEntry == nil ? nil : .easeOut(duration: 1)
			withAnimation(animation) {
				self.taskStartedEntry = entry
			}
		}
		.onAppear {
			self.recordStateCreatedEntryIfNeeded()
			let entry = self.record(.viewAppeared(self.label))
			let animation: Animation? = self.onAppearEntry == nil ? nil : .easeOut(duration: 1)
			withAnimation(animation) {
				self.onAppearEntry = entry
			}
		}
		.onDisappear {
			self.recordStateCreatedEntryIfNeeded()
			let entry = self.record(.viewDisappeared(self.label))
			let animation: Animation? = self.onDisappearEntry == nil ? nil : .easeOut(duration: 1)
			withAnimation(animation) {
				self.onDisappearEntry = entry
			}
		}
	}

	private func recordStateCreatedEntryIfNeeded() -> Void {
		guard self.stateCreatedEntry == nil else { return }
		let entry = TimelineEntry(event: .lifecycle(.stateCreated(self.label)))
		self.stateCreatedEntry = entry
		self.recordEntry(entry)
	}

	private func record(_ lifecycle: TimelineEntry.Event.Lifecycle) -> TimelineEntry {
		let entry = TimelineEntry(event: .lifecycle(lifecycle))
		self.recordEntry(entry)
		return entry
	}
}

#Preview {
	List {
		ForEach(1 ..< 100) { i in
			LifecycleMonitor(label: "\(i)")
		}
	}
}

enum LifecycleMonitorColors {
	private static var nextIndex: Int = 0

	private static let palette: [Color] = [
		.red,
		.orange,
		.yellow,
		.green,
		.mint,
		.teal,
		.cyan,
		.blue,
		.indigo,
		.purple,
		.pink,
		.brown,
	]

	static func next() -> Color {
		let color = self.palette[self.nextIndex % self.palette.count]
		self.nextIndex += 1
		return color
	}
}
