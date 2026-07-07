import SwiftUI

struct CaseStudyNavigationStack: View {
	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		NavigationStack {
			LevelView(
				level: .root,
				recordEntry: self.recordEntry,
				nextDestination: { $0 }
			)
			.navigationDestination(for: Level.self) { level in
				LevelView(
					level: level,
					recordEntry: self.recordEntry,
					nextDestination: { $0 }
				)
			}
		}
	}
}

extension CaseStudyNavigationStack {
	private static let explanation = "Navigation views keep the state of content views on the navigation stack alive. `task`, `onAppear`, and `onDisappear` get called as content moves on and off screen. Popping a view off the stack ends the view's lifetime, destroying its state."

	struct Level: Hashable {
		let value: Int

		static let root = Self(value: 1)

		var title: String {
			return self == .root ? "NavigationStack" : self.monitorLabel
		}

		var monitorLabel: String {
			return "Level \(self.value)"
		}

		var next: Self {
			return Self(value: self.value + 1)
		}
	}

	struct LevelView<Destination: Hashable>: View {
		let level: Level
		let recordEntry: (TimelineEntry) -> Void
		let nextDestination: (Level) -> Destination

		@Environment(\.lifecycleSessionEventLogInsetHeight) private var eventLogInsetHeight

		var body: some View {
			ScrollView {
				VStack(spacing: 16) {
					CaseStudyExplanation(
						text: CaseStudyNavigationStack.explanation
					)

					NavigationLink(value: self.nextDestination(self.level.next)) {
						HStack(spacing: 12) {
							LifecycleMonitor(
								label: self.level.monitorLabel,
								recordEntry: self.recordEntry
							)

							Image(systemName: "chevron.right")
								.font(.title3.weight(.semibold))
								.foregroundStyle(.secondary)
								.accessibilityHidden(true)
						}
						.contentShape(.rect)
					}
					.buttonStyle(.plain)
				}
				.padding()
			}
			.contentMargins(.bottom, self.eventLogInsetHeight, for: .scrollContent)
			.navigationTitle(self.level.title)
		}
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyNavigationStack { entry in
			recordEntry(.navigationStack, entry)
		}
	}
}
