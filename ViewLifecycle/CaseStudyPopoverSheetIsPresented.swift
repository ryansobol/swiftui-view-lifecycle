import SwiftUI

struct CaseStudyPopoverSheetIsPresented: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var isPresented = false

	var body: some View {
		TimelineCaseStudy(
			explanation: "`popover(isPresented:)` keeps the presenter alive while popover content appears. This study adapts the compact presentation to a sheet so it can be compared with `sheet(isPresented:)`."
		) {
			LifecycleMonitor(title: "Presenter", recordEntry: self.recordEntry)

			Button {
				self.present()
			} label: {
				Label("Present popover", systemImage: "rectangle.bottomthird.inset.filled")
			}
			.frame(maxWidth: .infinity)
			.buttonStyle(.glassProminent)
		}
		.popover(
			isPresented: self.$isPresented,
			attachmentAnchor: .point(.top),
			arrowEdge: .bottom
		) {
			IsPresentedPopoverSheetContent(recordEntry: self.recordEntry)
		}
	}

	private func present() -> Void {
		self.recordEntry(TimelineEntry(event: .action(.selected("Popover"))))

		self.isPresented = true
	}
}

private struct IsPresentedPopoverSheetContent: View {
	@Environment(\.dismiss) private var dismiss

	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		VStack(spacing: 16) {
			LifecycleMonitor(title: "Popover", recordEntry: self.recordEntry)

			CaseStudyExplanation(
				text: "This popover content is adapted to a sheet. Dismiss and present again to see whether the presented content gets fresh state."
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
		.presentationCompactAdaptation(.sheet)
		.presentationDetents([.medium, .large])
		.presentationDragIndicator(.visible)
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyPopoverSheetIsPresented { entry in
			recordEntry(.popoverSheetIsPresented, entry)
		}
	}
}
