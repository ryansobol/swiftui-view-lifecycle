import SwiftUI

struct RootView: View {
	#if !os(macOS)
		@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	#endif

	var body: some View {
		#if os(macOS)
			RegularRootView()
		#else
			if self.horizontalSizeClass == .compact {
				CompactRootView()
			}
			else {
				RegularRootView()
			}
		#endif
	}
}

struct CompactRootView: View {
	var body: some View {
		NavigationStack {
			Sidebar()
				.navigationDestination(for: CaseStudy.self) { caseStudy in
					Detail(caseStudy: caseStudy)
				}
		}
	}
}

struct RegularRootView: View {
	@State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn

	var body: some View {
		NavigationSplitView(columnVisibility: self.$columnVisibility) {
			Sidebar()
				.navigationDestination(for: CaseStudy.self) { caseStudy in
					RegularDetail(caseStudy: caseStudy)
				}
		} detail: {
			Detail(caseStudy: nil)
		}
	}
}

struct Sidebar: View {
	var body: some View {
		List {
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

struct RegularDetail: View {
	let caseStudy: CaseStudy

	var body: some View {
		switch self.caseStudy {
		case .navigationStack:
			CaseStudyNavigationStack()
				.navigationTitle(self.caseStudy.label)
				#if !os(macOS)
					.navigationBarTitleDisplayMode(.inline)
				#endif
		default:
			Detail(caseStudy: self.caseStudy)
		}
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
			CaseStudyNavigationStack.Content()
		case .tabView:
			CaseStudyTabView()
		}
	}
}

#Preview {
	RootView()
}
