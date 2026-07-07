import SwiftUI

struct CaseStudyScrollViewStatic: View {
	var body: some View {
		ScrollViewCaseStudy(
			caseStudy: .scrollViewStatic,
			explanation: "Static `ScrollView` content is created with the scroll view, even when part of that content starts off screen. The event log may not match visual order, but it shows that Top and Bottom both appear before scrolling to Bottom.",
			isEventLogClearable: false
		) { recordEntry in
			LifecycleMonitor(label: "Top", recordEntry: recordEntry)

			VStack {
				Image(systemName: "arrow.down.circle.fill")
				Text("Scroll down")
			}
			.font(.largeTitle)
			.padding(.vertical)

			Spacer(minLength: 650)

			LifecycleMonitor(label: "Bottom", recordEntry: recordEntry)
		}
	}
}

#Preview {
	CaseStudyScrollViewStatic()
}
