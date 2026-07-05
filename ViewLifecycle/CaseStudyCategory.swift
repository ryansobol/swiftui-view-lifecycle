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
			id: "scrollview",
			label: "ScrollView",
			caseStudies: [
				.scrollViewStatic,
				.scrollViewDynamic,
			]
		),
		CaseStudyCategory(
			id: "list",
			label: "List",
			caseStudies: [
				.listDynamic,
				.listStatic,
			]
		),
		CaseStudyCategory(
			id: "lazy",
			label: "Lazy containers",
			caseStudies: [
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
