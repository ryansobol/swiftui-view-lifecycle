import SwiftUI

struct ScrollViewCaseStudy<Content: View>: View {
	let explanation: String
	let usesSwipeActionsContainer: Bool
	@ViewBuilder let content: () -> Content

	@Environment(\.lifecycleSessionEventLogInsetHeight) private var eventLogInsetHeight

	init(
		explanation: String,
		usesSwipeActionsContainer: Bool = false,
		@ViewBuilder content: @escaping () -> Content
	) {
		self.explanation = explanation
		self.usesSwipeActionsContainer = usesSwipeActionsContainer
		self.content = content
	}

	var body: some View {
		if self.usesSwipeActionsContainer {
			self.scrollView
				.caseStudySwipeActionsContainer()
		}
		else {
			self.scrollView
		}
	}

	private var scrollView: some View {
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
			LifecycleMonitor(title: "Preview monitor", recordEntry: { _ in })
		}
	}
}
