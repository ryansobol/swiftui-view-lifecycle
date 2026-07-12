import SwiftUI

struct CaseStudyPopoverCoverIsPresented: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var isPresented = false

	var body: some View {
		TimelineCaseStudy(
			explanation: "`popover(isPresented:)` keeps the presenter alive while popover content appears. This study adapts the compact presentation to a cover so it can be compared with `fullScreenCover(isPresented:)`."
		) {
			LifecycleMonitor(title: "Presenter", recordEntry: self.recordEntry)

			Button {
				self.present()
			} label: {
				Label("Present popover", systemImage: "rectangle.inset.filled")
			}
			.frame(maxWidth: .infinity)
			.buttonStyle(.glassProminent)
		}
		.popover(
			isPresented: self.$isPresented,
			attachmentAnchor: .point(.top),
			arrowEdge: .bottom
		) {
			IsPresentedPopoverCoverContent(recordEntry: self.recordEntry)
		}
	}

	private func present() -> Void {
		self.recordEntry(TimelineEntry(event: .action(.tapped("Present popover"))))

		self.isPresented = true
	}
}

private struct IsPresentedPopoverCoverContent: View {
	@Environment(\.dismiss) private var dismiss

	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		VStack(spacing: 16) {
			LifecycleMonitor(title: "Popover", recordEntry: self.recordEntry)

			CaseStudyExplanation(
				text: "This popover content is adapted to a cover. Dismiss and present again to see whether the presented content gets fresh state."
			)

			Button(role: .destructive) {
				self.recordEntry(TimelineEntry(event: .action(.tapped("Dismiss popover"))))

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
		.frame(maxHeight: .infinity, alignment: .top)
		.padding()
		.presentationCompactAdaptation(.fullScreenCover)
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyPopoverCoverIsPresented { entry in
			recordEntry(.popoverCoverIsPresented, entry)
		}
	}
}
