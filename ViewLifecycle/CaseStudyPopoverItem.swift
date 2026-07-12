import SwiftUI

struct CaseStudyPopoverItem: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var presentedPopover: PresentedPopover? = nil

	var body: some View {
		TimelineCaseStudy(
			explanation: "`popover(item:)` keeps the presenter alive while the selected item presents popover content. Replacing the item preserves the popover's identity and reuses its state, even as the popover disappears, reappears, and restarts its task."
		) {
			LifecycleMonitor(title: "Presenter", recordEntry: self.recordEntry)

			VStack(spacing: 12) {
				ForEach(PresentedPopover.allCases) { popover in
					Button {
						self.present(popover)
					} label: {
						Label(popover.presentationButtonLabel, systemImage: popover.systemImage)
					}
					.buttonStyle(.glassProminent)
				}
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.popover(
				item: self.$presentedPopover,
				attachmentAnchor: .point(.top),
				arrowEdge: .bottom
			) { popover in
				PopoverContent(
					popover: popover,
					recordEntry: self.recordEntry,
					present: self.present
				)
				.presentationCompactAdaptation(.popover)
			}
		}
	}

	private func present(_ popover: PresentedPopover) -> Void {
		self.recordEntry(TimelineEntry(event: .action(.selected(popover.monitorLabel))))

		self.presentedPopover = popover
	}
}

private enum PresentedPopover: String, CaseIterable, Identifiable {
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

private struct PopoverContent: View {
	let popover: PresentedPopover
	let recordEntry: (TimelineEntry) -> Void
	let present: (PresentedPopover) -> Void

	var body: some View {
		VStack(spacing: 12) {
			LifecycleMonitor(
				title: "Popover",
				subtitle: "Showing \(self.popover.monitorLabel)",
				style: .standard,
				recordEntry: self.recordEntry
			)

			Button {
				self.present(self.popover.alternate)
			} label: {
				Label(
					self.popover.alternate.replacementButtonLabel,
					systemImage: self.popover.alternate.systemImage
				)
			}
			.buttonStyle(.glassProminent)
		}
		.padding(16)
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyPopoverItem { entry in
			recordEntry(.popoverItem, entry)
		}
	}
}
