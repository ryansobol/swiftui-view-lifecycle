import Foundation

struct CaseStudyEvent: Identifiable {
	let id = UUID()
	let timestamp: Date
	let kind: Kind

	init(timestamp: Date = .now, kind: Kind) {
		self.timestamp = timestamp
		self.kind = kind
	}

	enum Kind {
		case lifecycle(Lifecycle)
		case action(Action)
		case transition(Transition)

		enum Lifecycle {
			case stateCreated
			case taskStarted
			case viewAppeared
			case viewDisappeared
		}

		enum Action {
			case toggled(isOn: Bool)
			case selected(String)
			case tapped(String)
			case inserted(String)
			case deleted(String)
			case navigated(String)
		}

		enum Transition {
			case showStarted
			case showCompleted
			case hideStarted
			case hideCompleted
		}
	}
}

extension CaseStudyEvent.Kind {
	var label: String {
		return switch self {
		case .lifecycle(.stateCreated): "state created"
		case .lifecycle(.taskStarted): "task started"
		case .lifecycle(.viewAppeared): "view appeared"
		case .lifecycle(.viewDisappeared): "view disappeared"
		case let .action(.toggled(isOn)): isOn ? "toggled on" : "toggled off"
		case let .action(.selected(label)): "\(label) selected"
		case let .action(.tapped(label)): "\(label) tapped"
		case let .action(.inserted(label)): "\(label) inserted"
		case let .action(.deleted(label)): "\(label) deleted"
		case let .action(.navigated(label)): "\(label) navigated"
		case .transition(.showStarted): "show transition started"
		case .transition(.showCompleted): "show transition completed"
		case .transition(.hideStarted): "hide transition started"
		case .transition(.hideCompleted): "hide transition completed"
		}
	}
}
