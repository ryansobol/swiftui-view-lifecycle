import SwiftUI

struct CaseStudyIfTransition: View {
	private static let demonstrationAnimationDuration: TimeInterval = 0.75

	let recordEntry: (TimelineEntry) -> Void

	@State private var isShowingPanel = false

	var body: some View {
		TimelineCaseStudy(
			explanation: "This case study compares lifecycle events with animation completion. The panel is conditionally inserted and removed with a move transition, so the event log shows whether `task`, `onAppear`, and `onDisappear` happen when the transition starts or when it finishes."
		) {
			Button(self.panelButtonLabel) {
				self.recordEntry(TimelineEntry(event: .action(.tapped(self.panelButtonLabel))))
				self.togglePanel(recordEntry: self.recordEntry)
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
					TransitionPanel(recordEntry: self.recordEntry)
						.frame(width: 280)
						.transition(.move(edge: .leading))
						.zIndex(1)
				}
			}
			.frame(height: 220)
			.clipped()
		}
	}

	private var panelButtonLabel: String {
		return self.isShowingPanel ? "Hide panel" : "Show panel"
	}

	private func togglePanel(recordEntry: @escaping (TimelineEntry) -> Void) -> Void {
		let startedEvent: TimelineEntry.Event = self.isShowingPanel
			? .transition(.hideStarted)
			: .transition(.showStarted)
		let completedEvent: TimelineEntry.Event = self.isShowingPanel
			? .transition(.hideCompleted)
			: .transition(.showCompleted)

		recordEntry(TimelineEntry(event: startedEvent))

		withAnimation(
			.smooth(duration: Self.demonstrationAnimationDuration),
			completionCriteria: .logicallyComplete
		) {
			self.isShowingPanel.toggle()
		} completion: {
			recordEntry(TimelineEntry(event: completedEvent))
		}
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
		.background {
			RoundedRectangle(cornerRadius: 8)
				.fill(Color.gray100)
		}
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyIfTransition { entry in
			recordEntry(.ifTransition, entry)
		}
	}
}
