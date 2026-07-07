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
			case adjusted(String)
			case appended(String)
			case deleted(String)
			case popped(String)
			case prepended(String)
			case pushed(String)
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
		case let .action(.adjusted(label)): "\(label) adjusted"
		case let .action(.appended(label)): "\(label) appended"
		case let .action(.deleted(label)): "\(label) deleted"
		case let .action(.popped(label)): "\(label) popped"
		case let .action(.prepended(label)): "\(label) prepended"
		case let .action(.pushed(label)): "\(label) pushed"
		case let .action(.selected(label)): "\(label) selected"
		case let .action(.tapped(label)): "\(label) tapped"
		case let .action(.toggled(isOn)): isOn ? "toggled on" : "toggled off"
		case let .lifecycle(.stateCreated(label)): "\(label) state created"
		case let .lifecycle(.taskStarted(label)): "\(label) task started"
		case let .lifecycle(.viewAppeared(label)): "\(label) view appeared"
		case let .lifecycle(.viewDisappeared(label)): "\(label) view disappeared"
		case .transition(.hideCompleted): "Hide transition completed"
		case .transition(.hideStarted): "Hide transition started"
		case .transition(.showCompleted): "Show transition completed"
		case .transition(.showStarted): "Show transition started"
		}
	}
}
