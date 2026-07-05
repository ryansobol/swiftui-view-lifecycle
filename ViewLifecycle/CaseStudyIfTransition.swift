import SwiftUI

struct CaseStudyIfTransition: View {
	private static let demonstrationAnimationDuration: TimeInterval = 1.5

	@State private var isShowingPanel = false
	@State private var events = [TransitionEvent]()

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
		.navigationTitle("if transition")
	}

	private func togglePanel() -> Void {
		let action: TransitionAction = self.isShowingPanel ? .hide : .show

		self.log(action.startedEvent)

		if #available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
			withAnimation(
				.smooth(duration: Self.demonstrationAnimationDuration),
				completionCriteria: .logicallyComplete
			) {
				self.isShowingPanel.toggle()
			} completion: {
				self.log(action.completedEvent)
			}
		}
		else {
			withAnimation(.smooth(duration: Self.demonstrationAnimationDuration)) {
				self.isShowingPanel.toggle()
			}

			DispatchQueue.main.asyncAfter(deadline: .now() + Self.demonstrationAnimationDuration) {
				self.log(action.completedEvent)
			}
		}
	}

	private func log(_ kind: TransitionEvent.Kind) -> Void {
		let event = TransitionEvent(kind: kind, timestamp: .now)
		print("\(event.timestamp) transition: \(event.kind.logLabel)")
		self.events.append(event)
	}

	private func clearEvents() -> Void {
		self.events.removeAll()
	}
}

private struct TransitionPanel: View {
	@Environment(\.colorScheme) private var colorScheme

	let log: (TransitionEvent.Kind) -> Void

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
			self.log(.task)
		}
		.onAppear {
			self.log(.onAppear)
		}
		.onDisappear {
			self.log(.onDisappear)
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
	let events: [TransitionEvent]
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

private struct TransitionEvent: Identifiable {
	let id: UUID
	let kind: Kind
	let timestamp: Date

	init(kind: Kind, timestamp: Date) {
		self.id = UUID()
		self.kind = kind
		self.timestamp = timestamp
	}

	enum Kind {
		case showStarted
		case showCompleted
		case hideStarted
		case hideCompleted
		case task
		case onAppear
		case onDisappear

		var label: LocalizedStringKey {
			return LocalizedStringKey(self.logLabel)
		}

		var logLabel: String {
			return switch self {
			case .showStarted: "show tapped"
			case .showCompleted: "show animation completed"
			case .hideStarted: "hide tapped"
			case .hideCompleted: "hide animation completed"
			case .task: "task"
			case .onAppear: "onAppear"
			case .onDisappear: "onDisappear"
			}
		}
	}
}

private enum TransitionAction {
	case show
	case hide

	var startedEvent: TransitionEvent.Kind {
		return switch self {
		case .show: .showStarted
		case .hide: .hideStarted
		}
	}

	var completedEvent: TransitionEvent.Kind {
		return switch self {
		case .show: .showCompleted
		case .hide: .hideCompleted
		}
	}
}

#Preview {
	CaseStudyIfTransition()
}
