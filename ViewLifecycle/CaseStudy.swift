enum CaseStudy: Hashable {
	case coverIsPresented
	case coverItem
	case id
	case ifElse
	case ifTransition
	case lazyVGrid
	case lazyVStack
	case list
	case navigationStack
	case opacity
	case popoverIsPresented
	case popoverItem
	case popoverSheetIsPresented
	case popoverSheetItem
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
		case .coverIsPresented: ".fullScreenCover(isPresented:)"
		case .coverItem: ".fullScreenCover(item:)"
		case .id: ".id(_:)"
		case .ifElse: "if/else"
		case .ifTransition: "if transition"
		case .lazyVGrid: "ScrollView + LazyVGrid"
		case .lazyVStack: "ScrollView + LazyVStack"
		case .list: "List"
		case .navigationStack: "NavigationStack"
		case .opacity: ".opacity(_:)"
		case .popoverIsPresented: ".popover(isPresented:)"
		case .popoverItem: ".popover(item:)"
		case .popoverSheetIsPresented: ".popover(isPresented:) as sheet"
		case .popoverSheetItem: ".popover(item:) as sheet"
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
		case .coverIsPresented: "Shows the presenter staying alive while cover content appears and disappears."
		case .coverItem: "Shows the presenter staying alive while cover content changes with the selected item."
		case .id: "Shows how changing view identity replaces a view."
		case .ifElse: "Shows how switching conditional branches changes view identity."
		case .ifTransition: "Shows how transition timing affects an inserted view's lifetime and identity."
		case .lazyVGrid: "Shows grid cells starting lazily in batches of rows."
		case .lazyVStack: "Shows stack children starting lazily near the viewport."
		case .list: "Shows List rows starting lazily and being recycled."
		case .navigationStack: "Shows how stack levels stay alive until a pop removes them."
		case .opacity: "Shows that hiding a view with opacity keeps it alive."
		case .popoverIsPresented: "Shows the presenter staying alive while popover content appears and disappears."
		case .popoverItem: "Shows the presenter staying alive while popover content changes with the selected item."
		case .popoverSheetIsPresented: "Shows the presenter staying alive while popover sheet content appears and disappears."
		case .popoverSheetItem: "Shows the presenter staying alive while popover sheet content swaps between items."
		case .sheetIsPresented: "Shows the presenter staying alive while sheet content appears and disappears."
		case .sheetItem: "Shows the presenter staying alive while sheet content swaps between items."
		case .switch: "Shows how each selected case has its own view identity."
		case .tabView: "Shows how tabs are created on demand and kept alive offscreen."
		case .vStack: "Shows stack children starting eagerly before scrolling."
		}
	}

	var logCategory: String {
		return switch self {
		case .coverIsPresented: "case-study.cover-is-presented"
		case .coverItem: "case-study.cover-item"
		case .id: "case-study.id"
		case .ifElse: "case-study.if-else"
		case .ifTransition: "case-study.if-transition"
		case .lazyVGrid: "case-study.lazy-v-grid"
		case .lazyVStack: "case-study.lazy-v-stack"
		case .list: "case-study.list"
		case .navigationStack: "case-study.navigation-stack"
		case .opacity: "case-study.opacity"
		case .popoverIsPresented: "case-study.popover-is-presented"
		case .popoverItem: "case-study.popover-item"
		case .popoverSheetIsPresented: "case-study.popover-sheet-is-presented"
		case .popoverSheetItem: "case-study.popover-sheet-item"
		case .sheetIsPresented: "case-study.sheet-is-presented"
		case .sheetItem: "case-study.sheet-item"
		case .switch: "case-study.switch"
		case .tabView: "case-study.tab-view"
		case .vStack: "case-study.v-stack"
		}
	}
}
