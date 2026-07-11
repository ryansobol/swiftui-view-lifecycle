import SwiftUI

struct CaseStudyCoverIsPresented: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var isPresented = false

	var body: some View {
		TimelineCaseStudy(
			explanation: "`fullScreenCover(isPresented:)` keeps the presenter alive while cover content appears. When the content disappears, presenting the cover again recreates fresh content."
		) {
			LifecycleMonitor(title: "Presenter", recordEntry: self.recordEntry)

			Button {
				self.present()
			} label: {
				Label("Present cover", systemImage: "rectangle.inset.filled")
			}
			.buttonStyle(.glassProminent)
			.frame(maxWidth: .infinity)
		}
		.fullScreenCover(isPresented: self.$isPresented) {
			IsPresentedCoverContent(recordEntry: self.recordEntry)
		}
	}

	private func present() -> Void {
		self.recordEntry(TimelineEntry(event: .action(.selected("Cover"))))

		self.isPresented = true
	}
}

private struct IsPresentedCoverContent: View {
	@Environment(\.dismiss) private var dismiss

	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		VStack(spacing: 16) {
			LifecycleMonitor(title: "Cover", recordEntry: self.recordEntry)

			CaseStudyExplanation(
				text: "This content exists only while the cover is presented. Dismiss and present again to see a new `Cover` monitor."
			)

			Button(role: .destructive) {
				self.recordEntry(TimelineEntry(event: .action(.tapped("Dismiss cover"))))

				self.dismiss()
			} label: {
				Label {
					Text("Dismiss")
						.foregroundStyle(.primary)
				} icon: {
					Image(systemName: "xmark.circle")
				}
				.lineLimit(1)
			}
			.buttonStyle(.glassProminent)
			.tint(.red)
			.frame(maxWidth: .infinity, alignment: .center)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.padding()
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyCoverIsPresented { entry in
			recordEntry(.coverIsPresented, entry)
		}
	}
}
