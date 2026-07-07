import SwiftUI

struct ListCaseStudy<Content: View>: View {
	let explanation: String
	@ViewBuilder let content: () -> Content

	@Environment(\.lifecycleSessionBottomScrollContentMargin) private var bottomScrollContentMargin

	var body: some View {
		List {
			CaseStudyExplanation(text: self.explanation)

			self.content()
		}
		.contentMargins(.bottom, self.bottomScrollContentMargin, for: .scrollContent)
	}
}

#Preview("List case study") {
	ListCaseStudyPreview()
}

private struct ListCaseStudyPreview: View {
	var body: some View {
		ListCaseStudy(
			explanation: "This preview exercises the list shell with a manual action and a lifecycle monitor."
		) {
			LifecycleMonitor(label: "Preview monitor", recordEntry: { _ in })
		}
	}
}
