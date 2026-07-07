import SwiftUI

struct CaseStudyIfElse: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var isShowingIfBranch = true

	var body: some View {
		TimelineCaseStudy(
			explanation: "Toggling the switch swaps the true and false branches of an `if`/`else` statement. Each toggle destroys the old branch and creates the new one: the new branch appears, the old branch disappears, then the new branch's `task` starts."
		) {
			Toggle(isOn: self.$isShowingIfBranch) {
				Text("if/else toggle")
			}
			.onChange(of: self.isShowingIfBranch) { _, newValue in
				self.recordEntry(TimelineEntry(event: .action(.toggled(isOn: newValue))))
			}

			if self.isShowingIfBranch {
				LifecycleMonitor(label: "if", recordEntry: self.recordEntry)
			}
			else {
				LifecycleMonitor(label: "else", recordEntry: self.recordEntry)
			}
		}
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyIfElse { entry in
			recordEntry(.ifElse, entry)
		}
	}
}
