import SwiftUI

struct CaseStudyIfElse: View {
	@State private var isShowingIfBranch = true

	var body: some View {
		TimelineCaseStudy(
			caseStudy: .ifElse,
			explanation: "Toggling the switch swaps the true and false branches of an `if`/`else` statement. Each toggle destroys the old branch and creates the new one: the new branch appears, the old branch disappears, then the new branch's `task` starts."
		) { recordEntry in
			Toggle(isOn: self.$isShowingIfBranch) {
				Text("if/else toggle")
			}
			.onChange(of: self.isShowingIfBranch) { _, newValue in
				recordEntry(TimelineEntry(event: .action(.toggled(isOn: newValue))))
			}

			if self.isShowingIfBranch {
				LifecycleMonitor(label: "if", recordEntry: recordEntry)
			}
			else {
				LifecycleMonitor(label: "else", recordEntry: recordEntry)
			}
		}
	}
}

#Preview {
	CaseStudyIfElse()
}
