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
	let recordEntry: (TimelineEntry) -> Void

	@State private var selectedCase: SwitchCase = .one

	var body: some View {
		TimelineCaseStudy(
			explanation: "Selecting a segment activates a different `switch` branch. Each case has its own view identity, so switching away removes that branch and returning to it creates state again."
		) {
			Picker("Selection", selection: self.$selectedCase) {
				ForEach(SwitchCase.allCases) { switchCase in
					Text(switchCase.rawValue).tag(switchCase)
				}
			}
			.pickerStyle(.segmented)
			.onChange(of: self.selectedCase) { _, newValue in
				self.recordEntry(TimelineEntry(event: .action(.selected(newValue.rawValue))))
			}

			switch self.selectedCase {
			case .one:
				LifecycleMonitor(label: SwitchCase.one.rawValue, recordEntry: self.recordEntry)

			case .two:
				LifecycleMonitor(label: SwitchCase.two.rawValue, recordEntry: self.recordEntry)

			case .three:
				LifecycleMonitor(label: SwitchCase.three.rawValue, recordEntry: self.recordEntry)
			}
		}
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudySwitch { entry in
			recordEntry(.switch, entry)
		}
	}
}
