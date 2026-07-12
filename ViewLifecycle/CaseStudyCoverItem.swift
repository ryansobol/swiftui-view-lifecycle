import SwiftUI

struct CaseStudyCoverItem: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var presentedCover: PresentedCover? = nil

	var body: some View {
		TimelineCaseStudy(
			explanation: "`fullScreenCover(item:)` keeps the presenter alive while the selected item present the cover content. Replacing the item preserves the cover's identity and reuses its state, even as the cover disappears, re-appears, and restarts its task again."
		) {
			LifecycleMonitor(title: "Presenter", recordEntry: self.recordEntry)

			VStack(spacing: 12) {
				ForEach(PresentedCover.allCases) { cover in
					Button {
						self.present(cover)
					} label: {
						Label(cover.presentationButtonLabel, systemImage: cover.systemImage)
					}
					.buttonStyle(.glassProminent)
				}
			}
			.frame(maxWidth: .infinity, alignment: .center)
		}
		.fullScreenCover(item: self.$presentedCover) { cover in
			CoverContent(
				cover: cover,
				recordEntry: self.recordEntry,
				present: self.present
			)
		}
	}

	private func present(_ cover: PresentedCover) -> Void {
		self.recordEntry(TimelineEntry(event: .action(.selected(cover.monitorLabel))))

		self.presentedCover = cover
	}
}

private enum PresentedCover: String, CaseIterable, Identifiable {
	case first
	case second

	var id: Self {
		self
	}

	var presentationButtonLabel: String {
		return switch self {
		case .first: "Present 1st cover"
		case .second: "Present 2nd cover"
		}
	}

	var replacementButtonLabel: String {
		return switch self {
		case .first: "Replace with 1st cover"
		case .second: "Replace with 2nd cover"
		}
	}

	var monitorLabel: String {
		return switch self {
		case .first: "1st cover"
		case .second: "2nd cover"
		}
	}

	var systemImage: String {
		return switch self {
		case .first: "1.circle"
		case .second: "2.circle"
		}
	}

	var alternate: Self {
		return switch self {
		case .first: .second
		case .second: .first
		}
	}
}

private struct CoverContent: View {
	@Environment(\.dismiss) private var dismiss

	let cover: PresentedCover
	let recordEntry: (TimelineEntry) -> Void
	let present: (PresentedCover) -> Void

	var body: some View {
		VStack(spacing: 16) {
			LifecycleMonitor(
				title: "Cover",
				subtitle: "Showing \(self.cover.monitorLabel)",
				recordEntry: self.recordEntry
			)

			CaseStudyExplanation(
				text: "This cover is showing `\(self.cover.monitorLabel)`. Replacing the item updates the cover content, reusing the cover view's identity and `@State` while `onDisappear`, `onAppear`, and `task` run together."
			)

			VStack(spacing: 12) {
				Button {
					self.present(self.cover.alternate)
				} label: {
					Label(
						self.cover.alternate.replacementButtonLabel,
						systemImage: self.cover.alternate.systemImage
					)
				}
				.buttonStyle(.glassProminent)

				Button(role: .destructive) {
					self.recordEntry(
						TimelineEntry(event: .action(.tapped("Dismiss \(self.cover.monitorLabel)")))
					)

					self.dismiss()
				} label: {
					Label {
						Text("Dismiss")
							.foregroundStyle(.primary)
					} icon: {
						Image(systemName: "xmark.circle")
					}
				}
				.buttonStyle(.glassProminent)
				.tint(.red)
			}
		}
		.frame(maxHeight: .infinity, alignment: .top)
		.padding()
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyCoverItem { entry in
			recordEntry(.coverItem, entry)
		}
	}
}
