import SwiftUI

struct EventLog: View {
	@Binding var events: [CaseStudyEvent]

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			EventLogHeader(
				isClearDisabled: self.events.isEmpty,
				onClear: self.clearEvents
			)

			EventLogContent(events: self.events)
		}
		.font(.callout)
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.background(.quinary, in: .rect(corners: .concentric))
		.containerShape(.rect(cornerRadius: 8))
	}

	private func clearEvents() -> Void {
		self.events.removeAll()
	}
}

private struct EventLogHeader: View {
	let isClearDisabled: Bool
	let onClear: () -> Void

	var body: some View {
		HStack {
			Text("Event log")
				.font(.headline)

			Spacer()

			Button("Clear", role: .destructive, action: self.onClear)
				.buttonStyle(.glassProminent)
				.controlSize(.small)
				.disabled(self.isClearDisabled)
		}
	}
}

private struct EventLogContent: View {
	let events: [CaseStudyEvent]

	var body: some View {
		Group {
			if self.events.isEmpty {
				EventLogEmptyState()
			}
			else {
				EventLogEntries(events: self.events)
			}
		}
	}
}

private struct EventLogEmptyState: View {
	var body: some View {
		Text("No events yet")
			.foregroundStyle(.secondary)
	}
}

private struct EventLogEntries: View {
	let events: [CaseStudyEvent]

	var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading, spacing: 6) {
				ForEach(self.events) { event in
					EventLogRow(event: event)
				}
			}
		}
	}
}

private struct EventLogRow: View {
	let event: CaseStudyEvent

	var body: some View {
		HStack(alignment: .firstTextBaseline) {
			Text(self.event.timestamp, style: .timer)
				.monospacedDigit()
				.foregroundStyle(.secondary)
				.frame(width: 56, alignment: .leading)

			Text(self.event.kind.label)
		}
	}
}

#Preview {
	EventLogPreview()
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
}

private struct EventLogPreview: View {
	@State private var events = Self.initialEvents
	@State private var nextEventIndex = 0

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			HStack(spacing: 8) {
				Button("Add event", action: self.addEvent)
					.buttonStyle(.glassProminent)

				Button("Add sequence", action: self.addSequence)
					.buttonStyle(.glass)

				Button("Reset", action: self.resetEvents)
					.buttonStyle(.glass)
			}

			EventLog(events: self.$events)
				.layoutPriority(1)
		}
	}

	private func addEvent() -> Void {
		self.events.append(CaseStudyEvent(kind: Self.sampleKinds[self.nextEventIndex]))
		self.nextEventIndex = (self.nextEventIndex + 1) % Self.sampleKinds.count
	}

	private func addSequence() -> Void {
		for kind in Self.sampleKinds {
			self.events.append(CaseStudyEvent(kind: kind))
		}
	}

	private func resetEvents() -> Void {
		self.events = Self.initialEvents
		self.nextEventIndex = 0
	}

	private static var initialEvents: [CaseStudyEvent] {
		return [
			.init(timestamp: .now.addingTimeInterval(-8), kind: .transition(.showStarted)),
			.init(timestamp: .now.addingTimeInterval(-6), kind: .lifecycle(.taskStarted)),
			.init(timestamp: .now.addingTimeInterval(-4), kind: .lifecycle(.viewAppeared)),
			.init(timestamp: .now.addingTimeInterval(-2), kind: .transition(.showCompleted)),
		]
	}

	private static let sampleKinds: [CaseStudyEvent.Kind] = [
		.action(.tapped("Show panel")),
		.transition(.showStarted),
		.lifecycle(.taskStarted),
		.lifecycle(.viewAppeared),
		.transition(.showCompleted),
		.action(.tapped("Hide panel")),
		.transition(.hideStarted),
		.lifecycle(.viewDisappeared),
		.transition(.hideCompleted),
	]
}
