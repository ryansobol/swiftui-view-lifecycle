struct CaseStudyCategory: Identifiable {
	let id: String
	let label: String
	let caseStudies: [CaseStudy]
}

extension CaseStudyCategory {
	static let all = [
		CaseStudyCategory(
			id: "view-identity",
			label: "View identity",
			caseStudies: [
				.ifElse,
				.switch,
				.id,
				.opacity,
				.ifTransition,
			]
		),
		CaseStudyCategory(
			id: "scrolling-containers",
			label: "Scrolling containers",
			caseStudies: [
				.list,
				.vStack,
				.lazyVStack,
				.lazyVGrid,
			]
		),
		CaseStudyCategory(
			id: "presentation-containers",
			label: "Presentation containers",
			caseStudies: [
				.navigationStack,
				.tabView,
				.sheetIsPresented,
				.sheetItem,
			]
		),
	]
}
