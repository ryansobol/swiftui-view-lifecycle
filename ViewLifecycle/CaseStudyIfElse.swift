import SwiftUI

struct CaseStudyIfElse: View {
	@State private var events = [CaseStudyEvent]()
	@State private var flag = true

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Toggle(isOn: self.$flag) {
				Text("if/else toggle")
			}
			.onChange(of: self.flag) { _, newValue in
				self.log(.action(.toggled(isOn: newValue)))
			}

			if self.flag {
				LoggedLifecycleMonitor(label: "on", log: self.log)
			}
			else {
				LoggedLifecycleMonitor(label: "off", log: self.log)
			}

			EventLog(events: self.$events)
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

	private func log(_ kind: CaseStudyEvent.Kind) -> Void {
		let event = CaseStudyEvent(kind: kind)
		print("\(event.timestamp) if/else: \(event.kind.label)")
		self.events.append(event)
	}
}

private struct LoggedLifecycleMonitor: View {
	let label: String
	let log: (CaseStudyEvent.Kind) -> Void

	var body: some View {
		LifecycleMonitor(label: self.label)
			.task {
				self.log(.lifecycle(.taskStarted))
			}
			.onAppear {
				self.log(.lifecycle(.viewAppeared))
			}
			.onDisappear {
				self.log(.lifecycle(.viewDisappeared))
			}
	}
}

#Preview {
	CaseStudyIfElse()
}
