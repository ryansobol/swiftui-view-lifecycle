import SwiftUI

struct CaseStudyIDModifier: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var generation: Int = 0

	var body: some View {
		TimelineCaseStudy(
			explanation: "Changing `.id(_:)` gives the view a new identity without changing the surrounding layout. SwiftUI replaces the old view with a new one, so state is created again and the previous view disappears."
		) {
			Button("Increment view ID") {
				self.recordEntry(TimelineEntry(event: .action(.tapped("Increment view ID"))))
				self.generation += 1
			}
			.buttonStyle(.glassProminent)

			LifecycleMonitor(label: ".id(\(self.generation))", recordEntry: self.recordEntry)
				.id(self.generation)
		}
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyIDModifier { entry in
			recordEntry(.id, entry)
		}
	}
}
