import OSLog
import SwiftUI

struct CaseStudyIfTransition: View {
	private static let demonstrationAnimationDuration: TimeInterval = 0.75

	@State private var isShowingPanel = false
	@State private var entries = [TimelineEntry]()

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Button(self.panelButtonLabel) {
				self.record(.action(.tapped(self.panelButtonLabel)))
				self.togglePanel()
			}
			.buttonStyle(.glassProminent)

			ZStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: 8)
					.fill(Color.gray50)
					.overlay {
						Text("Host view")
							.foregroundStyle(Color.gray700)
					}

				if self.isShowingPanel {
					TransitionPanel(recordEntry: self.record)
						.frame(width: 280)
						.transition(.move(edge: .leading))
						.zIndex(1)
				}
			}
			.frame(height: 220)
			.clipped()

			EventLog(entries: self.$entries)
				.layoutPriority(1)

			Text(
				"This case study compares lifecycle events with animation completion. The panel is conditionally inserted and removed with a move transition, so the event log shows whether `task`, `onAppear`, and `onDisappear` happen when the transition starts or when it finishes."
			)
			.font(.callout)
			.fixedSize(horizontal: false, vertical: true)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}

	private var panelButtonLabel: String {
		return self.isShowingPanel ? "Hide panel" : "Show panel"
	}

	private func togglePanel() -> Void {
		let startedEvent: TimelineEntry.Event = self.isShowingPanel
			? .transition(.hideStarted)
			: .transition(.showStarted)
		let completedEvent: TimelineEntry.Event = self.isShowingPanel
			? .transition(.hideCompleted)
			: .transition(.showCompleted)

		self.record(startedEvent)

		if #available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
			withAnimation(
				.smooth(duration: Self.demonstrationAnimationDuration),
				completionCriteria: .logicallyComplete
			) {
				self.isShowingPanel.toggle()
			} completion: {
				self.record(completedEvent)
			}
		}
		else {
			withAnimation(.smooth(duration: Self.demonstrationAnimationDuration)) {
				self.isShowingPanel.toggle()
			}

			DispatchQueue.main.asyncAfter(deadline: .now() + Self.demonstrationAnimationDuration) {
				self.record(completedEvent)
			}
		}
	}

	private func record(_ event: TimelineEntry.Event) -> Void {
		let entry = TimelineEntry(event: event)
		self.record(entry)
	}

	private func record(_ entry: TimelineEntry) -> Void {
		Logger.caseStudyIfTransition.info("\(entry.event.label, privacy: .public)")
		self.entries.append(entry)
	}
}

private struct TransitionPanel: View {
	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		VStack(spacing: 12) {
			Text("Panel")
				.font(.headline)

			LifecycleMonitor(label: "Panel", recordEntry: self.recordEntry)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background {
			RoundedRectangle(cornerRadius: 8)
				.fill(Color.gray100)
		}
	}
}

#Preview {
	CaseStudyIfTransition()
}
