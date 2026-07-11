import SwiftUI

struct CaseStudyIfElse: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var isShowingIfBranch = true

	var body: some View {
		TimelineCaseStudy(
			explanation: "Toggling the switch swaps between two conditional branches. Each branch has its own view identity, so SwiftUI creates a fresh lifetime for the new branch while ending the previous branch's lifetime."
		) {
			Toggle(isOn: self.$isShowingIfBranch) {
				Text("if/else toggle")
			}
			.onChange(of: self.isShowingIfBranch) { _, newValue in
				self.recordEntry(TimelineEntry(event: .action(.toggled(isOn: newValue))))
			}

			if self.isShowingIfBranch {
				LifecycleMonitor(title: "if", recordEntry: self.recordEntry)
			}
			else {
				LifecycleMonitor(title: "else", recordEntry: self.recordEntry)
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
