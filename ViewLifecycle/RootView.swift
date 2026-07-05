import SwiftUI

struct RootView: View {
	@State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
	@State private var selection: CaseStudy.ID? = nil

	var body: some View {
		NavigationSplitView(columnVisibility: self.$columnVisibility) {
			Sidebar(selection: self.$selection)
		} detail: {
			if let selection = self.selection {
				MainContent(caseStudyID: selection)
			}
			else {
				Text("Select a case study.")
			}
		}
	}
}

struct Sidebar: View {
	@Binding var selection: CaseStudy.ID?

	var body: some View {
		List(selection: self.$selection) {
			ForEach(categories) { section in
				Section {
					ForEach(section.elements) { caseStudy in
						NavigationLink(value: caseStudy.id) {
							CaseStudyRow(caseStudy: caseStudy)
						}
					}
				} header: {
					Text(section.label)
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

struct MainContent: View {
	var caseStudyID: CaseStudy.ID

	var body: some View {
		switch self.caseStudyID {
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
