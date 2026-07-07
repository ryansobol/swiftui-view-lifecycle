import OSLog
import SwiftUI

struct ListCaseStudy<Content: View>: View {
	let caseStudy: CaseStudy
	let explanation: String
	var isEventLogClearable = true
	@ViewBuilder let content: (_ recordEntry: @escaping (TimelineEntry) -> Void) -> Content

	@State private var entries = [TimelineEntry]()

	var body: some View {
		List {
			CaseStudyExplanation(text: self.explanation)

			self.content(self.recordEntry)
		}
		.safeAreaInset(edge: .bottom) {
			EventLog(
				entries: self.$entries,
				isShowingClearButton: self.isEventLogClearable
			)
			.frame(height: 220)
			.padding()
			.background(.regularMaterial)
		}
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

#Preview("List case study") {
	ListCaseStudyPreview()
}

private struct ListCaseStudyPreview: View {
	var body: some View {
		ListCaseStudy(
			caseStudy: .listStatic,
			explanation: "This preview exercises the list shell with a manual action and a lifecycle monitor. The shell owns the event log and logging; the monitor only reports lifecycle entries through the entry sink."
		) { recordEntry in
			LifecycleMonitor(label: "Preview monitor", recordEntry: recordEntry)
		}
	}
}
