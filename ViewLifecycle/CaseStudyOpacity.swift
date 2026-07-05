import SwiftUI

struct CaseStudyOpacity: View {
	@State private var opacity: Double = 1.0

	var body: some View {
		VStack {
			LabeledContent {
				Slider(value: self.$opacity, in: 0 ... 1)
			} label: {
				Text("Opacity: \(self.opacity, format: .percent.precision(.fractionLength(0)))")
			}
			LifecycleMonitor(label: ".opacity(_:)")
				.opacity(self.opacity)
			Text(
				"The `.opacity` modifier has no effect on a view’s lifecycle. Setting the opacity to 0 does *not* call `onDisappear`."
			)
			.font(.callout)
			.frame(maxWidth: .infinity, alignment: .leading)
		}
		.padding()
	}
}

#Preview {
	CaseStudyOpacity()
}
