import SwiftUI

struct TimelineCaseStudy<Content: View>: View {
	let explanation: String
	@ViewBuilder let content: () -> Content

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			CaseStudyExplanation(text: self.explanation)

			self.content()
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}
}

#Preview("Timeline case study") {
	TimelineCaseStudyPreview()
}

private struct TimelineCaseStudyPreview: View {
	var body: some View {
		TimelineCaseStudy(
			explanation: "This preview exercises the timeline shell with a manual action and a lifecycle monitor."
		) {
			LifecycleMonitor(title: "Preview monitor", recordEntry: { _ in })
		}
	}
}
