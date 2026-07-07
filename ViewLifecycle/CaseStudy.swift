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
		case .listDynamic: "Dynamic List"
		case .listStatic: "Static List"
		case .navigationStack: "NavigationStack"
		case .opacity: ".opacity(_:)"
		case .scrollViewDynamic: "Dynamic ScrollView"
		case .scrollViewStatic: "Static ScrollView"
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

	var logCategory: String {
		return switch self {
		case .id: "case-study.id"
		case .ifElse: "case-study.if-else"
		case .ifTransition: "case-study.if-transition"
		case .lazyVGrid: "case-study.lazy-v-grid"
		case .lazyVStack: "case-study.lazy-v-stack"
		case .listDynamic: "case-study.list-dynamic"
		case .listStatic: "case-study.list-static"
		case .navigationStack: "case-study.navigation-stack"
		case .opacity: "case-study.opacity"
		case .scrollViewDynamic: "case-study.scroll-view-dynamic"
		case .scrollViewStatic: "case-study.scroll-view-static"
		case .switch: "case-study.switch"
		case .tabView: "case-study.tab-view"
		}
	}
}
