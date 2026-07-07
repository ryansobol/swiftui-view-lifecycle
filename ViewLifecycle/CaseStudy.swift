enum CaseStudy: Hashable {
	case dynamicLazyVGrid
	case dynamicLazyVStack
	case dynamicList
	case dynamicVStack
	case id
	case ifElse
	case ifTransition
	case navigationStack
	case opacity
	case staticList
	case staticVStack
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
		case .dynamicLazyVGrid: "Dynamic LazyVGrid"
		case .dynamicLazyVStack: "Dynamic LazyVStack"
		case .dynamicList: "Dynamic List"
		case .dynamicVStack: "Dynamic VStack"
		case .id: ".id(_:)"
		case .ifElse: "if/else"
		case .ifTransition: "if transition"
		case .navigationStack: "NavigationStack"
		case .opacity: ".opacity(_:)"
		case .staticList: "Static List"
		case .staticVStack: "Static VStack"
		case .switch: "switch"
		case .tabView: "TabView"
		}
	}

	var description: String {
		return switch self {
		case .dynamicLazyVGrid: "Shows mutable grid cells starting lazily in batches."
		case .dynamicLazyVStack: "Shows mutable stack children starting lazily."
		case .dynamicList: "Shows mutable List rows starting lazily."
		case .dynamicVStack: "Shows mutable stack children starting eagerly."
		case .id: "Shows how changing view identity replaces a view."
		case .ifElse: "Shows how switching conditional branches changes view identity."
		case .ifTransition: "Shows how transition timing affects an inserted view's lifetime and identity."
		case .navigationStack: "Shows how stack levels stay alive until a pop removes them."
		case .opacity: "Shows that hiding a view with opacity keeps it alive."
		case .staticList: "Shows immutable List rows starting lazily."
		case .staticVStack: "Shows immutable stack children starting eagerly."
		case .switch: "Shows how each selected case has its own view identity."
		case .tabView: "Shows how tabs are created on demand and kept alive offscreen."
		}
	}

	var logCategory: String {
		return switch self {
		case .dynamicLazyVGrid: "case-study.dynamic-lazy-v-grid"
		case .dynamicLazyVStack: "case-study.dynamic-lazy-v-stack"
		case .dynamicList: "case-study.dynamic-list"
		case .dynamicVStack: "case-study.dynamic-v-stack"
		case .id: "case-study.id"
		case .ifElse: "case-study.if-else"
		case .ifTransition: "case-study.if-transition"
		case .navigationStack: "case-study.navigation-stack"
		case .opacity: "case-study.opacity"
		case .staticList: "case-study.static-list"
		case .staticVStack: "case-study.static-v-stack"
		case .switch: "case-study.switch"
		case .tabView: "case-study.tab-view"
		}
	}
}
