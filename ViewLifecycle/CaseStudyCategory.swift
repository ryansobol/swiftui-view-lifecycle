struct CaseStudyCategory: Identifiable {
	let id: String
	let label: String
	let caseStudies: [CaseStudy]
}

extension CaseStudyCategory {
	static let all = [
		CaseStudyCategory(
			id: "simple",
			label: "Simple views",
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
				.scrollViewStatic,
				.listStatic,
				.scrollViewDynamic,
				.listDynamic,
				.lazyVStack,
				.lazyVGrid,
			]
		),
		CaseStudyCategory(
			id: "navigation",
			label: "Navigation containers",
			caseStudies: [
				.navigationStack,
				.tabView,
			]
		),
	]
}
