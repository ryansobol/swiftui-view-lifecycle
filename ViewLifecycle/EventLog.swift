import SwiftUI

struct EventLog: View {
	@Binding var entries: [TimelineEntry]

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			EventLogHeader(
				isClearDisabled: self.entries.isEmpty,
				onClear: self.clearEntries
			)

			EventLogContent(entries: self.entries)
		}
		.font(.callout)
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.background(Color.gray50, in: .rect(corners: .concentric))
		.containerShape(.rect(cornerRadius: 8))
	}

	private func clearEntries() -> Void {
		self.entries.removeAll()
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
				.tint(Color.red400)
				.disabled(self.isClearDisabled)
		}
	}
}

private struct EventLogContent: View {
	let entries: [TimelineEntry]

	var body: some View {
		Group {
			if self.entries.isEmpty {
				EventLogEmptyState()
			}
			else {
				EventLogEntries(entries: self.entries)
			}
		}
	}
}

private struct EventLogEmptyState: View {
	var body: some View {
		Text("No events yet")
			.foregroundStyle(Color.gray600)
	}
}

private struct EventLogEntries: View {
	let entries: [TimelineEntry]

	@State private var scrollPosition = ScrollPosition(edge: .bottom)

	var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading, spacing: 2) {
				ForEach(self.entries) { entry in
					EventLogRow(entry: entry)
				}
			}
		}
		.scrollPosition(self.$scrollPosition)
		.scrollIndicatorsFlash(trigger: self.entries.count)
		.onChange(of: self.entries.count) {
			withAnimation {
				self.scrollPosition.scrollTo(edge: .bottom)
			}
		}
	}
}

private struct EventLogRow: View {
	let entry: TimelineEntry

	var body: some View {
		HStack(alignment: .firstTextBaseline) {
			TimelineEntryAge(entry: self.entry)
				.foregroundStyle(Color.gray600)
				.frame(width: 56, alignment: .leading)

			Text(self.entry.event.label)
				.foregroundStyle(self.foregroundStyle(for: self.entry.event))
		}
		.padding(.horizontal, 4)
		.padding(.vertical, 2)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(self.backgroundStyle(for: self.entry.event), in: .rect(corners: .concentric))
		.containerShape(.rect(cornerRadius: 4))
	}

	private func backgroundStyle(for event: TimelineEntry.Event) -> Color.Shade {
		return switch event {
		case .action: Color.green50
		case .lifecycle: Color.blue50
		case .transition: Color.purple50
		}
	}

	private func foregroundStyle(for event: TimelineEntry.Event) -> Color.Shade {
		return switch event {
		case .action: Color.green950
		case .lifecycle: Color.blue950
		case .transition: Color.purple950
		}
	}
}

#Preview {
	EventLogPreview()
}

private struct EventLogPreview: View {
	@State private var entries = Self.initialEntries
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

			EventLog(entries: self.$entries)
				.layoutPriority(1)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}

	private func addEvent() -> Void {
		self.entries.append(TimelineEntry(event: Self.sampleEvents[self.nextEventIndex]))
		self.nextEventIndex = (self.nextEventIndex + 1) % Self.sampleEvents.count
	}

	private func addSequence() -> Void {
		for event in Self.sampleEvents {
			self.entries.append(TimelineEntry(event: event))
		}
	}

	private func resetEvents() -> Void {
		self.entries = Self.initialEntries
		self.nextEventIndex = 0
	}

	private static var initialEntries: [TimelineEntry] {
		return [
			.init(timestamp: .now.addingTimeInterval(-8), event: .transition(.showStarted)),
			.init(timestamp: .now.addingTimeInterval(-6), event: .lifecycle(.stateCreated("Panel"))),
			.init(timestamp: .now.addingTimeInterval(-5), event: .lifecycle(.taskStarted("Panel"))),
			.init(timestamp: .now.addingTimeInterval(-4), event: .lifecycle(.viewAppeared("Panel"))),
			.init(timestamp: .now.addingTimeInterval(-2), event: .transition(.showCompleted)),
		]
	}

	private static let sampleEvents: [TimelineEntry.Event] = [
		.action(.tapped("Show panel")),
		.transition(.showStarted),
		.lifecycle(.stateCreated("Panel")),
		.lifecycle(.taskStarted("Panel")),
		.lifecycle(.viewAppeared("Panel")),
		.transition(.showCompleted),
		.action(.tapped("Hide panel")),
		.transition(.hideStarted),
		.lifecycle(.viewDisappeared("Panel")),
		.transition(.hideCompleted),
	]
}
