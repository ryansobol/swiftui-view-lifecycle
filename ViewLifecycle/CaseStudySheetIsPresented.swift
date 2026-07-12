import SwiftUI

struct CaseStudySheetIsPresented: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var isPresented = false

	var body: some View {
		TimelineCaseStudy(
			explanation: "`sheet(isPresented:)` keeps the presenter alive while sheet content appears. When the sheet disappears, presenting the sheet again recreates fresh content."
		) {
			LifecycleMonitor(title: "Presenter", recordEntry: self.recordEntry)

			Button {
				self.present()
			} label: {
				Label("Present sheet", systemImage: "rectangle.bottomthird.inset.filled")
			}
			.frame(maxWidth: .infinity)
			.buttonStyle(.glassProminent)
		}
		.sheet(isPresented: self.$isPresented) {
			IsPresentedSheetContent(recordEntry: self.recordEntry)
		}
	}

	private func present() -> Void {
		self.recordEntry(TimelineEntry(event: .action(.selected("Sheet"))))

		self.isPresented = true
	}
}

private struct IsPresentedSheetContent: View {
	@Environment(\.dismiss) private var dismiss

	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		VStack(spacing: 16) {
			LifecycleMonitor(title: "Sheet", recordEntry: self.recordEntry)

			CaseStudyExplanation(
				text: "This content exists only while the sheet is presented. Dismiss and present again to see a new `Sheet` monitor."
			)

			Button(role: .destructive) {
				self.recordEntry(TimelineEntry(event: .action(.tapped("Dismiss sheet"))))

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
		.presentationDetents([.medium, .large])
		.presentationDragIndicator(.visible)
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudySheetIsPresented { entry in
			recordEntry(.sheetIsPresented, entry)
		}
	}
}
