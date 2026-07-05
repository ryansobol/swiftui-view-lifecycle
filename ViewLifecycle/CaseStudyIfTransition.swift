import SwiftUI

struct CaseStudyIfTransition: View {
	private static let demonstrationAnimationDuration: TimeInterval = 1.5

	@State private var isShowingPanel = false
	@State private var events = [CaseStudyEvent]()

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Button(self.isShowingPanel ? "Hide panel" : "Show panel") {
				self.togglePanel()
			}
			.buttonStyle(.borderedProminent)

			ZStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: 8)
					.fill(.secondary.opacity(0.12))
					.overlay {
						Text("Host view")
							.foregroundStyle(.secondary)
					}

				if self.isShowingPanel {
					TransitionPanel(log: self.log)
						.frame(width: 280)
						.transition(.move(edge: .leading))
						.zIndex(1)
				}
			}
			.frame(height: 220)
			.clipped()

			EventLog(events: self.events, onClear: self.clearEvents)
				.layoutPriority(1)

			Text(
				"This case study compares lifecycle events with animation completion. The panel is conditionally inserted and removed with a move transition, so the event log shows whether `task`, `onAppear`, and `onDisappear` happen when the transition starts or when it finishes."
			)
			.font(.callout)
			.frame(maxWidth: .infinity, alignment: .leading)
			.fixedSize(horizontal: false, vertical: true)
			.layoutPriority(2)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}

	private func togglePanel() -> Void {
		let startedEvent: CaseStudyEvent.Kind = self.isShowingPanel
			? .transition(.hideStarted)
			: .transition(.showStarted)
		let completedEvent: CaseStudyEvent.Kind = self.isShowingPanel
			? .transition(.hideCompleted)
			: .transition(.showCompleted)

		self.log(startedEvent)

		if #available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
			withAnimation(
				.smooth(duration: Self.demonstrationAnimationDuration),
				completionCriteria: .logicallyComplete
			) {
				self.isShowingPanel.toggle()
			} completion: {
				self.log(completedEvent)
			}
		}
		else {
			withAnimation(.smooth(duration: Self.demonstrationAnimationDuration)) {
				self.isShowingPanel.toggle()
			}

			DispatchQueue.main.asyncAfter(deadline: .now() + Self.demonstrationAnimationDuration) {
				self.log(completedEvent)
			}
		}
	}

	private func log(_ kind: CaseStudyEvent.Kind) -> Void {
		let event = CaseStudyEvent(kind: kind)
		print("\(event.timestamp) transition: \(event.kind.label)")
		self.events.append(event)
	}

	private func clearEvents() -> Void {
		self.events.removeAll()
	}
}

private struct TransitionPanel: View {
	@Environment(\.colorScheme) private var colorScheme

	let log: (CaseStudyEvent.Kind) -> Void

	var body: some View {
		VStack(spacing: 12) {
			Text("Panel")
				.font(.headline)

			LifecycleMonitor(label: "Transition panel")
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background {
			RoundedRectangle(cornerRadius: 8)
				.fill(self.backgroundColor)
				.overlay {
					RoundedRectangle(cornerRadius: 8)
						.fill(.blue.opacity(0.18))
				}
				.overlay {
					RoundedRectangle(cornerRadius: 8)
						.stroke(.blue.opacity(0.35))
				}
		}
		.task {
			self.log(.lifecycle(.taskStarted))
		}
		.onAppear {
			self.log(.lifecycle(.viewAppeared))
		}
		.onDisappear {
			self.log(.lifecycle(.viewDisappeared))
		}
	}

	private var backgroundColor: Color {
		return switch self.colorScheme {
		case .dark: Color(red: 0.08, green: 0.12, blue: 0.16)
		default: Color(red: 0.88, green: 0.94, blue: 1.0)
		}
	}
}

private struct EventLog: View {
	let events: [CaseStudyEvent]
	let onClear: () -> Void

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Text("Event log")
					.font(.headline)

				Spacer()

				Button("Clear", action: self.onClear)
					.disabled(self.events.isEmpty)
			}

			if self.events.isEmpty {
				Text("No events yet.")
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
			}
			else {
				ScrollView {
					LazyVStack(alignment: .leading, spacing: 6) {
						ForEach(self.events) { event in
							HStack(alignment: .firstTextBaseline) {
								Text(event.timestamp, style: .timer)
									.monospacedDigit()
									.foregroundStyle(.secondary)
									.frame(width: 72, alignment: .leading)

								Text(event.kind.label)
							}
							.frame(maxWidth: .infinity, alignment: .leading)
						}
					}
					.frame(maxWidth: .infinity, alignment: .topLeading)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
			}
		}
		.font(.callout)
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.frame(minHeight: 0)
		.background {
			RoundedRectangle(cornerRadius: 8)
				.fill(.secondary.opacity(0.08))
		}
	}
}

#Preview {
	CaseStudyIfTransition()
}
