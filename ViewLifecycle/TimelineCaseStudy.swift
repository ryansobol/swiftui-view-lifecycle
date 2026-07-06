import OSLog
import SwiftUI

struct TimelineCaseStudy<Content: View>: View {
	let caseStudy: CaseStudy
	let explanation: String
	@ViewBuilder let content: (_ recordEntry: @escaping (TimelineEntry) -> Void) -> Content

	@State private var entries = [TimelineEntry]()

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			self.content(self.recordEntry)

			EventLog(entries: self.$entries)
				.layoutPriority(1)

			Text(self.explanation)
				.font(.callout)
				.fixedSize(horizontal: false, vertical: true)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}

	private var logger: Logger {
		return .caseStudy(self.caseStudy)
	}

	private func recordEntry(_ entry: TimelineEntry) -> Void {
		#if DEBUG
			print("\(entry.timestamp) \(entry.event.label)")
		#else
			self.logger.info("\(entry.event.label, privacy: .public)")
		#endif

		self.entries.append(entry)
	}
}

#Preview("Timeline case study") {
	TimelineCaseStudyPreview()
}

private struct TimelineCaseStudyPreview: View {
	var body: some View {
		TimelineCaseStudy(
			caseStudy: .ifTransition,
			explanation: "This preview exercises the timeline shell with a manual action and a lifecycle monitor. The shell owns the event log and logging; the monitor only reports lifecycle entries through the entry sink."
		) { recordEntry in
			Button("Record") {
				recordEntry(TimelineEntry(event: .action(.tapped("Preview button"))))
			}
			.buttonStyle(.glassProminent)

			LifecycleMonitor(label: "Preview monitor", recordEntry: recordEntry)
		}
	}
}
