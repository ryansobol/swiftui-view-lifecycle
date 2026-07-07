import SwiftUI

struct CaseStudyNavigationStack: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var path = [Level]()

	var body: some View {
		NavigationStack(path: self.$path) {
			LevelView(
				level: .root,
				recordEntry: self.recordEntry,
				pushLevel: self.pushLevel
			)
			.navigationDestination(for: Level.self) { level in
				LevelView(
					level: level,
					recordEntry: self.recordEntry,
					pushLevel: self.pushLevel
				)
			}
		}
		.onChange(of: self.path) { oldPath, newPath in
			self.recordPoppedLevels(from: oldPath, to: newPath)
		}
	}

	private func pushLevel(_ level: Level) -> Void {
		self.recordEntry(TimelineEntry(event: .action(.pushed(level.monitorLabel))))
		self.path.append(level)
	}

	private func recordPoppedLevels(from oldPath: [Level], to newPath: [Level]) -> Void {
		guard oldPath.count > newPath.count else { return }

		for level in oldPath.dropFirst(newPath.count).reversed() {
			self.recordEntry(TimelineEntry(event: .action(.popped(level.monitorLabel))))
		}
	}
}

extension CaseStudyNavigationStack {
	private static let explanation =
		"Pushing adds a new level to the stack. Lower levels can disappear while they are covered, but their state stays alive until a pop removes them. When an existing level becomes visible again, it appears without creating new state."

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

	struct LevelView: View {
		let level: Level
		let recordEntry: (TimelineEntry) -> Void
		let pushLevel: (Level) -> Void

		@Environment(\.lifecycleSessionEventLogInsetHeight) private var eventLogInsetHeight

		var body: some View {
			ScrollView {
				VStack(spacing: 16) {
					CaseStudyExplanation(
						text: CaseStudyNavigationStack.explanation
					)

					Button {
						self.pushLevel(self.level.next)
					} label: {
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
