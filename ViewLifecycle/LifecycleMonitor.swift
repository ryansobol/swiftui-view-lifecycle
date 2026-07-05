import SwiftUI

/// A view that records and displays its lifecycle events.
struct LifecycleMonitor: View {
	var label: String
	@State private var stateTimestamp: Date = .now
	@State private var taskStartTimestamp: Date? = nil
	@State private var onAppearTimestamp: Date? = nil
	@State private var onDisappearTimestamp: Date? = nil
	@State private var color: Color = LifecycleMonitorColors.next()

	var body: some View {
		VStack(spacing: 16) {
			Text(self.label)
				.font(.title3)
			Grid(horizontalSpacing: 16) {
				GridRow(alignment: .firstTextBaseline) {
					Text("@State")
						.gridColumnAlignment(.leading)
					Text("\(self.stateTimestamp, style: .timer) ago")
						.monospacedDigit()
						.gridColumnAlignment(.leading)
				}
				.help("When the state (incl. @State and @StateObject) for this view was created")

				GridRow(alignment: .firstTextBaseline) {
					Text("task")
					Text(self.timestampLabel(for: self.taskStartTimestamp))
						.monospacedDigit()
				}
				.help("When task was last called for this view")

				GridRow(alignment: .firstTextBaseline) {
					Text("onAppear")
					Text(self.timestampLabel(for: self.onAppearTimestamp))
						.monospacedDigit()
				}
				.help("When onAppear was last called for this view")

				GridRow(alignment: .firstTextBaseline) {
					Text("onDisappear")
					Text(self.timestampLabel(for: self.onDisappearTimestamp))
						.monospacedDigit()
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
			let timestamp = Date.now
			print("\(timestamp) \(self.label): task started")
			let animation: Animation? = self.taskStartTimestamp == nil ? nil : .easeOut(duration: 1)
			withAnimation(animation) {
				self.taskStartTimestamp = timestamp
			}
		}
		.onAppear {
			let timestamp = Date.now
			print("\(timestamp) \(self.label): onAppear")
			let animation: Animation? = self.onAppearTimestamp == nil ? nil : .easeOut(duration: 1)
			withAnimation(animation) {
				self.onAppearTimestamp = timestamp
			}
		}
		.onDisappear {
			let timestamp = Date.now
			print("\(timestamp) \(self.label): onDisappear")
			let animation: Animation? = self.onDisappearTimestamp == nil ? nil : .easeOut(duration: 1)
			withAnimation(animation) {
				self.onDisappearTimestamp = timestamp
			}
		}
	}

	private func timestampLabel(for timestamp: Date?) -> LocalizedStringKey {
		if let t = timestamp {
			return "\(t, style: .timer) ago"
		}
		else {
			return "never"
		}
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
