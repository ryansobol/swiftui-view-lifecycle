import SwiftUI

struct ScrollViewCaseStudy<Content: View>: View {
	let explanation: String
	@ViewBuilder let content: () -> Content

	@Environment(\.lifecycleSessionEventLogInsetHeight) private var eventLogInsetHeight

	var body: some View {
		ScrollView {
			VStack(spacing: 16) {
				CaseStudyExplanation(text: self.explanation)

				self.content()
			}
			.padding()
		}
		.contentMargins(.bottom, self.eventLogInsetHeight, for: .scrollContent)
	}
}

#Preview("Scroll view case study") {
	ScrollViewCaseStudyPreview()
}

private struct ScrollViewCaseStudyPreview: View {
	var body: some View {
		ScrollViewCaseStudy(
			explanation: "This preview exercises the scroll view shell with a manual action and a lifecycle monitor."
		) {
			LifecycleMonitor(label: "Preview monitor", recordEntry: { _ in })
		}
	}
}
