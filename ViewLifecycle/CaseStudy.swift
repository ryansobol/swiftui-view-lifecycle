enum CaseStudy: Hashable {
	case id
	case ifElse
	case ifTransition
	case lazyVGrid
	case lazyVStack
	case listDynamic
	case listStatic
	case navigationStack
	case opacity
	case scrollViewDynamic
	case scrollViewStatic
	case `switch`
	case tabView
}

extension CaseStudy: Identifiable {
	var id: Self {
		self
	}
}

extension CaseStudy {
	var label: String {
		return switch self {
		case .id: ".id(_:)"
		case .ifElse: "if/else"
		case .ifTransition: "if transition"
		case .lazyVGrid: "LazyVGrid"
		case .lazyVStack: "LazyVStack"
		case .listDynamic: "List with dynamic content"
		case .listStatic: "List with static content"
		case .navigationStack: "NavigationStack"
		case .opacity: ".opacity(_:)"
		case .scrollViewDynamic: "ScrollView with dynamic content"
		case .scrollViewStatic: "ScrollView with static content"
		case .switch: "switch"
		case .tabView: "TabView"
		}
	}

	var description: String {
		return switch self {
		case .ifTransition: "A conditionally inserted side panel with a move transition."
		case .scrollViewDynamic: "A VStack with dynamic content, embedded in a ScrollView."
		case .listStatic: "A List with a bunch of hardcoded child views, not using ForEach."
		case .navigationStack: "A NavigationStack with infinite levels of drill-down."
		case .tabView: "TabView with multiple tabs, each with static content."
		default: ""
		}
	}
}
