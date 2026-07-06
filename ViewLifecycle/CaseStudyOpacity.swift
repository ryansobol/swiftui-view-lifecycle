import SwiftUI

struct CaseStudyOpacity: View {
	@State private var opacity = 1.0

	var body: some View {
		TimelineCaseStudy(
			caseStudy: .opacity,
			explanation: "Changing `.opacity(_:)` adjusts how visible the lifecycle monitor is, but it does not change the monitor's identity. The event log shows opacity adjustments without new state, appearance, or disappearance events."
		) { recordEntry in
			LabeledContent {
				Slider(value: self.$opacity, in: 0 ... 1)
					.onChange(of: self.opacity) {
						recordEntry(
							TimelineEntry(event: .action(.adjusted("Opacity \(self.opacityPercentage)")))
						)
					}
			} label: {
				Text("Opacity: \(self.opacityPercentage)")
			}

			LifecycleMonitor(label: ".opacity(\(self.opacityPercentage))", recordEntry: recordEntry)
				.opacity(self.opacity)
		}
	}

	private var opacityPercentage: String {
		return self.opacity.formatted(.percent.precision(.fractionLength(0)))
	}
}

#Preview {
	CaseStudyOpacity()
}
