import SwiftUI

struct Category: Identifiable {
	let id: String
	let label: String
	let elements: [CaseStudy]
}

struct CaseStudy: Identifiable, Equatable {
	let id: ID
	let label: String
	let description: String

	init(id: ID, label: String, description: String = "") {
		self.id = id
		self.label = label
		self.description = description
	}

	enum ID: CaseIterable {
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
}

let categories: [Category] = [
	Category(
		id: "simple",
		label: "Simple views",
		elements: [
			CaseStudy(id: .ifElse, label: "if/else"),
			CaseStudy(id: .switch, label: "switch"),
			CaseStudy(id: .id, label: ".id(_:)"),
			CaseStudy(id: .opacity, label: ".opacity(_:)"),
			CaseStudy(
				id: .ifTransition,
				label: "if transition",
				description: "A conditionally inserted side panel with a move transition."
			),
		]
	),
	Category(
		id: "scrollview",
		label: "ScrollView",
		elements: [
			CaseStudy(id: .scrollViewStatic, label: "ScrollView with static content"),
			CaseStudy(
				id: .scrollViewDynamic,
				label: "ScrollView with dynamic content",
				description: "A VStack with dynamic content, embedded in a ScrollView."
			),
		]
	),
	Category(
		id: "list",
		label: "List",
		elements: [
			CaseStudy(id: .listDynamic, label: "List with dynamic content"),
			CaseStudy(
				id: .listStatic,
				label: "List with static content",
				description: "A List with a bunch of hardcoded child views, not using ForEach."
			),
		]
	),
	Category(
		id: "lazy",
		label: "Lazy containers",
		elements: [
			CaseStudy(id: .lazyVStack, label: "LazyVStack"),
			CaseStudy(id: .lazyVGrid, label: "LazyVGrid"),
		]
	),
	Category(
		id: "navigation",
		label: "Navigation containers",
		elements: [
			CaseStudy(
				id: .navigationStack,
				label: "NavigationStack",
				description: "A NavigationStack with infinite levels of drill-down."
			),
			CaseStudy(
				id: .tabView,
				label: "TabView",
				description: "TabView with multiple tabs, each with static content."
			),
		]
	),
]
