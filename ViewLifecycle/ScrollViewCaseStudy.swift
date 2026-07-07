import OSLog
import SwiftUI

struct ScrollViewCaseStudy<Content: View>: View {
	let caseStudy: CaseStudy
	let explanation: String
	var isEventLogClearable = true
	@ViewBuilder let content: (_ recordEntry: @escaping (TimelineEntry) -> Void) -> Content

	@State private var entries = [TimelineEntry]()

	var body: some View {
		ScrollView {
			VStack(spacing: 16) {
				CaseStudyExplanation(text: self.explanation)

				self.content(self.recordEntry)
			}
			.padding()
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
