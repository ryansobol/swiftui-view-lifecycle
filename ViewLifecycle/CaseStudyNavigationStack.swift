import SwiftUI

#if os(macOS)
	struct CaseStudyNavigationStackMac: View {
		@Environment(\.openWindow) private var openWindow: OpenWindowAction

		var body: some View {
			VStack {
				Text(
					"This example opens in a separate window because SwiftUI on macOS 13.1 can’t seem to handle a NavigationStack nested in a NavigationSplitView (or I’m holding it wrong; I’m running into an infinite loop with this setup)."
				)
				Button("Open NavigationStack window") {
					self.openWindow(id: "navigation-stack")
				}
			}
			.padding()
			.navigationTitle("NavigationStack")
		}
	}
#endif

struct CaseStudyNavigationStack: View {
	var body: some View {
		NavigationStack {
			Content(level: 1)
		}
	}

	struct Content: View {
		var level: Int

		var body: some View {
			List {
				Section {
					NavigationLink {
						Content(level: self.level + 1)
					} label: {
						LifecycleMonitor(label: "Level \(self.level)")
					}
				} footer: {
					if self.level == 1 {
						Text(
							"Navigation views keep the state of content views on the navigation stack alive. `task`, `onAppear`, and `onDisappear` get called as you navigate. Popping a view off the stack ends the view's lifetime, destroying its state."
						)
						.font(.callout)
						.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
			}
			.listStyle(.plain)
			.navigationTitle(self.level == 1 ? "NavigationStack" : "Level \(self.level)")
		}
	}
}

struct CaseStudyNavigationStack_Previews: PreviewProvider {
	static var previews: some View {
		CaseStudyNavigationStack()
	}
}
