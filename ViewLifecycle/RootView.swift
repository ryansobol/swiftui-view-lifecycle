import SwiftUI

struct RootView: View {
	@State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
	@State private var selectedCaseStudy: CaseStudy? = nil

	var body: some View {
		NavigationSplitView(columnVisibility: self.$columnVisibility) {
			Sidebar(selection: self.$selectedCaseStudy)
		} detail: {
			Detail(caseStudy: self.selectedCaseStudy)
		}
	}
}

struct Sidebar: View {
	@Binding var selection: CaseStudy?

	var body: some View {
		List(selection: self.$selection) {
			ForEach(CaseStudyCategory.all) { category in
				Section {
					ForEach(category.caseStudies) { caseStudy in
						NavigationLink(value: caseStudy) {
							CaseStudyRow(caseStudy: caseStudy)
						}
					}
				} header: {
					Text(category.label)
				}
			}
		}
		.navigationTitle("SwiftUI View Lifecycle")
		#if !os(macOS)
			.navigationBarTitleDisplayMode(.inline)
		#endif
	}
}

private struct CaseStudyRow: View {
	let caseStudy: CaseStudy

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(self.caseStudy.label)
				.lineLimit(nil)

			if !self.caseStudy.description.isEmpty {
				Text(self.caseStudy.description)
					.font(.callout)
					.foregroundStyle(.secondary)
					.lineLimit(nil)
			}
		}
	}
}

struct Detail: View {
	let caseStudy: CaseStudy?

	var body: some View {
		Group {
			if let caseStudy = self.caseStudy {
				MainContent(caseStudy: caseStudy)
			}
			else {
				Text("Select a case study.")
			}
		}
		.navigationTitle(self.caseStudy?.label ?? "")
		#if !os(macOS)
			.navigationBarTitleDisplayMode(.inline)
		#endif
	}
}

struct MainContent: View {
	var caseStudy: CaseStudy

	var body: some View {
		switch self.caseStudy {
		case .ifElse:
			CaseStudyIfElse()
		case .switch:
			CaseStudySwitch()
		case .id:
			CaseStudyIDModifier()
		case .opacity:
			CaseStudyOpacity()
		case .ifTransition:
			CaseStudyIfTransition()
		case .scrollViewStatic:
			CaseStudyScrollViewStatic()
		case .scrollViewDynamic:
			CaseStudyScrollViewDynamic()
		case .listDynamic:
			CaseStudyListDynamic()
		case .listStatic:
			CaseStudyListStatic()
		case .lazyVStack:
			CaseStudyLazyVStack()
		case .lazyVGrid:
			CaseStudyLazyVGrid()
		case .navigationStack:
			#if os(macOS)
				CaseStudyNavigationStackMac()
			#else
				CaseStudyNavigationStack()
			#endif
		case .tabView:
			CaseStudyTabView()
		}
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView()
	}
}
