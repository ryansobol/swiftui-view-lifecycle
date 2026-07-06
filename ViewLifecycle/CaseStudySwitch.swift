import SwiftUI

private enum SwitchCase: String, CaseIterable, Identifiable {
	case one = "One"
	case two = "Two"
	case three = "Three"

	var id: Self {
		return self
	}
}

struct CaseStudySwitch: View {
	@State private var selectedCase: SwitchCase = .one

	var body: some View {
		TimelineCaseStudy(
			caseStudy: .switch,
			explanation: "Selecting a segment activates a different `switch` branch. The event log shows each branch getting its own state and lifecycle events. Returning to a case creates fresh state for that branch instead of reusing the previous instance."
		) { recordEntry in
			Picker("Selection", selection: self.$selectedCase) {
				ForEach(SwitchCase.allCases) { switchCase in
					Text(switchCase.rawValue).tag(switchCase)
				}
			}
			.pickerStyle(.segmented)
			.onChange(of: self.selectedCase) { _, newValue in
				recordEntry(TimelineEntry(event: .action(.selected(newValue.rawValue))))
			}

			switch self.selectedCase {
			case .one:
				LifecycleMonitor(label: SwitchCase.one.rawValue, recordEntry: recordEntry)

			case .two:
				LifecycleMonitor(label: SwitchCase.two.rawValue, recordEntry: recordEntry)

			case .three:
				LifecycleMonitor(label: SwitchCase.three.rawValue, recordEntry: recordEntry)
			}
		}
	}
}

#Preview {
	CaseStudySwitch()
}
