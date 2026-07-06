import OSLog
import SwiftUI

struct CaseStudyIfElse: View {
	@State private var entries = [TimelineEntry]()
	@State private var flag = true

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Toggle(isOn: self.$flag) {
				Text("if/else toggle")
			}
			.onChange(of: self.flag) { _, newValue in
				self.record(.action(.toggled(isOn: newValue)))
			}

			if self.flag {
				LifecycleMonitor(label: "on", recordEntry: self.record)
			}
			else {
				LifecycleMonitor(label: "off", recordEntry: self.record)
			}

			EventLog(entries: self.$entries)
				.layoutPriority(1)

			Text(
				"Toggling the switch swaps the true and false branches of an `if`/`else` statement. Each toggle destroys the old branch and creates the new one: the new branch appears, the old branch disappears, then the new branch's `task` starts."
			)
			.font(.callout)
			.fixedSize(horizontal: false, vertical: true)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}

	private func record(_ event: TimelineEntry.Event) -> Void {
		let entry = TimelineEntry(event: event)
		self.record(entry)
	}

	private func record(_ entry: TimelineEntry) -> Void {
		Logger.caseStudyIfElse.info("\(entry.event.label, privacy: .public)")
		self.entries.append(entry)
	}
}

#Preview {
	CaseStudyIfElse()
}
