struct CaseStudyCategory: Identifiable {
	let id: String
	let label: String
	let caseStudies: [CaseStudy]
}

extension CaseStudyCategory {
	static let all = [
		CaseStudyCategory(
			id: "simple",
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
			id: "scrolling",
			label: "Scrolling containers",
			caseStudies: [
				.staticVStack,
				.dynamicVStack,
				.staticList,
				.dynamicList,
				.dynamicLazyVStack,
				.dynamicLazyVGrid,
			]
		),
		CaseStudyCategory(
			id: "navigation",
			label: "Presentation containers",
			caseStudies: [
				.navigationStack,
				.tabView,
			]
		),
	]
}
