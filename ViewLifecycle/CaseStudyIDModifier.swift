import SwiftUI

struct CaseStudyIDModifier: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var generation: Int = 0

	var body: some View {
		TimelineCaseStudy(
			explanation: "Changing `.id(_:)` gives the lifecycle monitor a new identity. The event log shows the previous monitor disappearing and a new monitor with fresh state appearing, even though the surrounding view stays in place."
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
