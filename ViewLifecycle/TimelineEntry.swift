import Foundation

struct TimelineEntry: Identifiable {
	let id = UUID()
	let timestamp: Date
	let event: Event

	init(timestamp: Date = .now, event: Event) {
		self.timestamp = timestamp
		self.event = event
	}

	enum Event {
		case action(Action)
		case lifecycle(Lifecycle)
		case transition(Transition)

		enum Action {
			case deleted(String)
			case inserted(String)
			case navigated(String)
			case selected(String)
			case tapped(String)
			case toggled(isOn: Bool)
		}

		enum Lifecycle {
			case stateCreated(String)
			case taskStarted(String)
			case viewAppeared(String)
			case viewDisappeared(String)
		}

		enum Transition {
			case hideCompleted
			case hideStarted
			case showCompleted
			case showStarted
		}
	}
}

extension TimelineEntry.Event {
	var label: String {
		return switch self {
		case let .action(.deleted(label)): "\(label) deleted"
		case let .action(.inserted(label)): "\(label) inserted"
		case let .action(.navigated(label)): "\(label) navigated"
		case let .action(.selected(label)): "\(label) selected"
		case let .action(.tapped(label)): "\(label) tapped"
		case let .action(.toggled(isOn)): isOn ? "toggled on" : "toggled off"
		case let .lifecycle(.stateCreated(label)): "\(label) state created"
		case let .lifecycle(.taskStarted(label)): "\(label) task started"
		case let .lifecycle(.viewAppeared(label)): "\(label) view appeared"
		case let .lifecycle(.viewDisappeared(label)): "\(label) view disappeared"
		case .transition(.hideCompleted): "hide transition completed"
		case .transition(.hideStarted): "hide transition started"
		case .transition(.showCompleted): "show transition completed"
		case .transition(.showStarted): "show transition started"
		}
	}
}
