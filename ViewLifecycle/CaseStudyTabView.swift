import SwiftUI

struct CaseStudyTabView: View {
	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		TabView {
			VStack {
				LifecycleMonitor(label: "Tab 1", recordEntry: self.recordEntry)
				Text(
					"`TabView` initializes the state for each tab’s content view all at once when it first appears. `task`, `onAppear`, and `onDisappear` get called as you switch between tabs. State of offscreen tabs is kept alive."
				)
				.font(.callout)
				.frame(maxWidth: .infinity, alignment: .leading)
			}
			.padding()
			.tabItem {
				Label("Tab 1", systemImage: "1.circle")
			}
			LifecycleMonitor(label: "Tab 2", recordEntry: self.recordEntry)
				.padding()
				.tabItem {
					Label("Tab 2", systemImage: "2.circle")
				}
			LifecycleMonitor(label: "Tab 3", recordEntry: self.recordEntry)
				.padding()
				.tabItem {
					Label("Tab 3", systemImage: "3.circle")
				}
			LifecycleMonitor(label: "Tab 4", recordEntry: self.recordEntry)
				.padding()
				.tabItem {
					Label("Tab 4", systemImage: "4.circle")
				}
		}
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyTabView { entry in
			recordEntry(.tabView, entry)
		}
	}
}
