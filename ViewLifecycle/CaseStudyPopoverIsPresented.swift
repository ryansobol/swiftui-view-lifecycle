import SwiftUI

struct CaseStudyPopoverIsPresented: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var isPresented = false

	var body: some View {
		TimelineCaseStudy(
			explanation: "`popover(isPresented:)` keeps the presenter alive while popover content appears. When the content disappears, presenting the popover again recreates fresh content."
		) {
			LifecycleMonitor(title: "Presenter", recordEntry: self.recordEntry)

			Button {
				self.present()
			} label: {
				Label("Present popover", systemImage: "rectangle.on.rectangle")
			}
			.buttonStyle(.glassProminent)
			.popover(
				isPresented: self.$isPresented,
				attachmentAnchor: .point(.top),
				arrowEdge: .bottom
			) {
				IsPresentedPopoverContent(recordEntry: self.recordEntry)
					.presentationCompactAdaptation(.popover)
			}
			.frame(maxWidth: .infinity)
		}
	}

	private func present() -> Void {
		self.recordEntry(TimelineEntry(event: .action(.selected("Popover"))))

		self.isPresented = true
	}
}

private struct IsPresentedPopoverContent: View {
	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		VStack(spacing: 12) {
			LifecycleMonitor(
				title: "Popover",
				style: .standard,
				recordEntry: self.recordEntry
			)
		}
		.padding(16)
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyPopoverIsPresented { entry in
			recordEntry(.popoverIsPresented, entry)
		}
	}
}
