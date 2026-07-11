enum CaseStudy: Hashable {
	case id
	case ifElse
	case ifTransition
	case lazyVGrid
	case lazyVStack
	case list
	case navigationStack
	case opacity
	case sheetIsPresented
	case sheetItem
	case `switch`
	case tabView
	case vStack
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
		case .lazyVGrid: "ScrollView + LazyVGrid"
		case .lazyVStack: "ScrollView + LazyVStack"
		case .list: "List"
		case .navigationStack: "NavigationStack"
		case .opacity: ".opacity(_:)"
		case .sheetIsPresented: ".sheet(isPresented:)"
		case .sheetItem: ".sheet(item:)"
		case .switch: "switch"
		case .tabView: "TabView"
		case .vStack: "ScrollView + VStack"
		}
	}

	var navigationTitle: String {
		return switch self {
		case .lazyVGrid: "ScrollView+LazyVGrid"
		case .lazyVStack: "ScrollView+LazyVStack"
		case .vStack: "ScrollView+VStack"
		default: self.label
		}
	}

	var description: String {
		return switch self {
		case .id: "Shows how changing view identity replaces a view."
		case .ifElse: "Shows how switching conditional branches changes view identity."
		case .ifTransition: "Shows how transition timing affects an inserted view's lifetime and identity."
		case .lazyVGrid: "Shows grid cells starting lazily in batches of rows."
		case .lazyVStack: "Shows stack children starting lazily near the viewport."
		case .list: "Shows List rows starting lazily and being recycled."
		case .navigationStack: "Shows how stack levels stay alive until a pop removes them."
		case .opacity: "Shows that hiding a view with opacity keeps it alive."
		case .sheetIsPresented: "Shows the presenter staying alive while sheet content appears and disappears."
		case .sheetItem: "Shows the presenter staying alive while sheet content swaps between items."
		case .switch: "Shows how each selected case has its own view identity."
		case .tabView: "Shows how tabs are created on demand and kept alive offscreen."
		case .vStack: "Shows stack children starting eagerly before scrolling."
		}
	}

	var logCategory: String {
		return switch self {
		case .id: "case-study.id"
		case .ifElse: "case-study.if-else"
		case .ifTransition: "case-study.if-transition"
		case .lazyVGrid: "case-study.lazy-v-grid"
		case .lazyVStack: "case-study.lazy-v-stack"
		case .list: "case-study.list"
		case .navigationStack: "case-study.navigation-stack"
		case .opacity: "case-study.opacity"
		case .sheetIsPresented: "case-study.sheet-is-presented"
		case .sheetItem: "case-study.sheet-item"
		case .switch: "case-study.switch"
		case .tabView: "case-study.tab-view"
		case .vStack: "case-study.v-stack"
		}
	}
}
