import SwiftUI

struct CaseStudyOpacity: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var opacity = 1.0

	var body: some View {
		TimelineCaseStudy(
			explanation: "Changing `.opacity(_:)` only changes how the view is drawn. Even at 0%, the view keeps its identity and state, so it does not disappear until it is removed from the screen."
		) {
			LabeledContent {
				Slider(value: self.$opacity, in: 0 ... 1)
					.onChange(of: self.opacity) {
						self.recordEntry(
							TimelineEntry(event: .action(.adjusted("Opacity \(self.opacityPercentage)")))
						)
					}
			} label: {
				Text("Opacity: \(self.opacityPercentage)")
			}

			LifecycleMonitor(label: ".opacity(\(self.opacityPercentage))", recordEntry: self.recordEntry)
				.opacity(self.opacity)
		}
	}

	private var opacityPercentage: String {
		return self.opacity.formatted(.percent.precision(.fractionLength(0)))
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyOpacity { entry in
			recordEntry(.opacity, entry)
		}
	}
}
