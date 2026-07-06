import SwiftUI

struct CaseStudyIDModifier: View {
	@State private var generation: Int = 0

	var body: some View {
		TimelineCaseStudy(
			caseStudy: .id,
			explanation: "Changing `.id(_:)` gives the lifecycle monitor a new identity. The event log shows the previous monitor disappearing and a new monitor with fresh state appearing, even though the surrounding view stays in place."
		) { recordEntry in
			Button("Increment view ID") {
				recordEntry(TimelineEntry(event: .action(.tapped("Increment view ID"))))
				self.generation += 1
			}
			.buttonStyle(.glassProminent)

			LifecycleMonitor(label: ".id(\(self.generation))", recordEntry: recordEntry)
				.id(self.generation)
		}
	}
}

#Preview {
	CaseStudyIDModifier()
}
