import SwiftUI

struct CaseStudyNavigationStack: View {
	var body: some View {
		NavigationStack {
			Content()
		}
	}
}

extension CaseStudyNavigationStack {
	struct Content: View {
		var body: some View {
			LevelView(level: .root)
				.navigationDestination(for: Level.self) { level in
					LevelView(level: level)
				}
		}
	}

	struct Level: Hashable {
		var value: Int

		static let root = Self(value: 1)

		var next: Self {
			Self(value: self.value + 1)
		}
	}

	struct LevelView: View {
		var level: Level

		var body: some View {
			List {
				Section {
					NavigationLink(value: self.level.next) {
						LifecycleMonitor(label: "Level \(self.level.value)")
					}
					.listRowSeparator(.hidden)
				} footer: {
					if self.level == .root {
						Text(
							"Navigation views keep the state of content views on the navigation stack alive. `task`, `onAppear`, and `onDisappear` get called as you navigate. Popping a view off the stack ends the view's lifetime, destroying its state."
						)
						.font(.callout)
						.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
				.listSectionSeparator(.hidden)
			}
			.listStyle(.plain)
			.navigationTitle(self.level == .root ? "NavigationStack" : "Level \(self.level.value)")
		}
	}
}

struct CaseStudyNavigationStack_Previews: PreviewProvider {
	static var previews: some View {
		CaseStudyNavigationStack()
	}
}
