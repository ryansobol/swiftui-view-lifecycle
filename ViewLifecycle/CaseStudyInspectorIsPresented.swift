import SwiftUI

struct CaseStudyInspectorIsPresented: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var isPresented = false

	var body: some View {
		TimelineCaseStudy(
			explanation: "`inspector(isPresented:)` creates inspector content with the presenter, before the inspector is visibly presented. Presenting after dismissal reappears the inspector and restarts its task while preserving the same state."
		) {
			LifecycleMonitor(title: "Presenter", recordEntry: self.recordEntry)

			Button {
				self.present()
			} label: {
				Label("Present inspector", systemImage: "sidebar.right")
			}
			.frame(maxWidth: .infinity)
			.buttonStyle(.glassProminent)
		}
		.inspector(isPresented: self.$isPresented) {
			InspectorContent(recordEntry: self.recordEntry)
		}
	}

	private func present() -> Void {
		self.recordEntry(TimelineEntry(event: .action(.tapped("Present inspector"))))

		self.isPresented = true
	}
}

private struct InspectorContent: View {
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.dismiss) private var dismiss

	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		VStack(spacing: 16) {
			LifecycleMonitor(title: "Inspector", recordEntry: self.recordEntry)

			CaseStudyExplanation(
				text: "This `Inspector` monitor is created before the inspector is shown. Dismiss and present again to see `onDisappear`, `onAppear`, and `task` restart while `@State` stays preserved."
			)

			Button(role: .destructive) {
				self.recordEntry(TimelineEntry(event: .action(.tapped("Dismiss inspector"))))

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
		.background(self.backgroundColor)
	}

	private var backgroundColor: Color {
		return switch self.colorScheme {
		case .dark: .black
		case .light: .white
		@unknown default: .black
		}
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyInspectorIsPresented { entry in
			recordEntry(.inspectorIsPresented, entry)
		}
	}
}
