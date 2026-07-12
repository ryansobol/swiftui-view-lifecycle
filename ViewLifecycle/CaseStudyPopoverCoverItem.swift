import SwiftUI

struct CaseStudyPopoverCoverItem: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var presentedPopover: PresentedCoverPopover? = nil

	var body: some View {
		TimelineCaseStudy(
			explanation: "`popover(item:)` keeps the presenter alive while the selected item presents popover content. This study adapts the compact presentation to a cover so it can be compared with `fullScreenCover(item:)`."
		) {
			LifecycleMonitor(title: "Presenter", recordEntry: self.recordEntry)

			VStack(spacing: 12) {
				ForEach(PresentedCoverPopover.allCases) { popover in
					Button {
						self.present(popover)
					} label: {
						Label(popover.presentationButtonLabel, systemImage: popover.systemImage)
					}
					.buttonStyle(.glassProminent)
				}
			}
			.frame(maxWidth: .infinity)
		}
		.popover(
			item: self.$presentedPopover,
			attachmentAnchor: .point(.top),
			arrowEdge: .bottom
		) { popover in
			PopoverCoverContent(
				popover: popover,
				recordEntry: self.recordEntry,
				present: self.present
			)
		}
	}

	private func present(_ popover: PresentedCoverPopover) -> Void {
		self.recordEntry(TimelineEntry(event: .action(.selected(popover.monitorLabel))))

		self.presentedPopover = popover
	}
}

private enum PresentedCoverPopover: String, CaseIterable, Identifiable {
	case first
	case second

	var id: Self {
		self
	}

	var presentationButtonLabel: String {
		return switch self {
		case .first: "Present 1st popover"
		case .second: "Present 2nd popover"
		}
	}

	var replacementButtonLabel: String {
		return switch self {
		case .first: "Replace with 1st popover"
		case .second: "Replace with 2nd popover"
		}
	}

	var monitorLabel: String {
		return switch self {
		case .first: "1st popover"
		case .second: "2nd popover"
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

private struct PopoverCoverContent: View {
	@Environment(\.dismiss) private var dismiss

	let popover: PresentedCoverPopover
	let recordEntry: (TimelineEntry) -> Void
	let present: (PresentedCoverPopover) -> Void

	var body: some View {
		VStack(spacing: 16) {
			LifecycleMonitor(
				title: "Popover",
				subtitle: "Showing \(self.popover.monitorLabel)",
				recordEntry: self.recordEntry
			)

			CaseStudyExplanation(
				text: "This popover is showing `\(self.popover.monitorLabel)` while adapting to a cover. Replace the item to compare whether the adapted presentation recreates state or reuses it."
			)

			VStack(spacing: 12) {
				Button {
					self.present(self.popover.alternate)
				} label: {
					Label(
						self.popover.alternate.replacementButtonLabel,
						systemImage: self.popover.alternate.systemImage
					)
				}
				.buttonStyle(.glassProminent)

				Button(role: .destructive) {
					self.recordEntry(
						TimelineEntry(event: .action(.tapped("Dismiss \(self.popover.monitorLabel)")))
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
		.presentationCompactAdaptation(.fullScreenCover)
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyPopoverCoverItem { entry in
			recordEntry(.popoverCoverItem, entry)
		}
	}
}
