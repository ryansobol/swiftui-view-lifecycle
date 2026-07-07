import OSLog
import SwiftUI

struct CaseStudyScrollViewStatic: View {
	@State private var entries = [TimelineEntry]()

	var body: some View {
		ScrollViewCaseStudy(
			explanation: "Static `ScrollView` content is created with the scroll view, even when part of that content starts off screen. The event log may not match visual order, but it shows that Top and Bottom both appear before scrolling to Bottom.",
			entries: self.$entries,
			isEventLogClearable: false
		) {
			LifecycleMonitor(label: "Top", recordEntry: self.recordEntry)

			VStack {
				Image(systemName: "arrow.down.circle.fill")
				Text("Scroll down")
			}
			.font(.largeTitle)
			.padding(.vertical)

			Spacer(minLength: 650)

			LifecycleMonitor(label: "Bottom", recordEntry: self.recordEntry)
		}
	}

	private var logger: Logger {
		return .caseStudy(.scrollViewStatic)
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

#Preview {
	CaseStudyScrollViewStatic()
}
