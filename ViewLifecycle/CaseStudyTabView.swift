import SwiftUI

struct CaseStudyTabView: View {
	fileprivate static let explanation = "`TabView` creates a tab's content the first time SwiftUI brings that tab into range. Switching tabs changes which content is visible, but previously created tabs can reappear with their existing state."

	let recordEntry: (TimelineEntry) -> Void

	@Environment(\.lifecycleSessionBottomScrollContentMargin) private var bottomContentMargin

	var body: some View {
		TabView {
			TabContent(label: "Tab 1", recordEntry: self.recordEntry)
				.tabItem {
					Label("Tab 1", systemImage: "1.circle")
				}

			TabContent(label: "Tab 2", recordEntry: self.recordEntry)
				.tabItem {
					Label("Tab 2", systemImage: "2.circle")
				}

			TabContent(label: "Tab 3", recordEntry: self.recordEntry)
				.tabItem {
					Label("Tab 3", systemImage: "3.circle")
				}

			TabContent(label: "Tab 4", recordEntry: self.recordEntry)
				.tabItem {
					Label("Tab 4", systemImage: "4.circle")
				}
		}
		.padding(.bottom, self.bottomContentMargin)
	}
}

private struct TabContent: View {
	let label: String
	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		VStack(spacing: 16) {
			LifecycleMonitor(label: self.label, recordEntry: self.recordEntry)

			CaseStudyExplanation(text: CaseStudyTabView.explanation)
		}
		.padding()
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyTabView { entry in
			recordEntry(.tabView, entry)
		}
	}
}
