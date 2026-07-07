import SwiftUI

struct RootView: View {
	#if !os(macOS)
		@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	#endif

	var body: some View {
		LifecycleSession { recordEntry in
			#if os(macOS)
				RegularRootView(recordEntry: recordEntry)
			#else
				if self.horizontalSizeClass == .compact {
					CompactRootView(recordEntry: recordEntry)
				}
				else {
					RegularRootView(recordEntry: recordEntry)
				}
			#endif
		}
	}
}

struct CompactRootView: View {
	let recordEntry: LifecycleSessionRecorder

	@State private var path = [CompactRoute]()

	var body: some View {
		NavigationStack(path: self.$path) {
			Sidebar(destination: CompactRoute.caseStudy)
				.navigationDestination(for: CompactRoute.self) { route in
					switch route {
					case .caseStudy(.navigationStack):
						CaseStudyNavigationStack.LevelView(
							level: .root,
							recordEntry: self.recordNavigationStackEntry,
							nextDestination: CompactRoute.navigationLevel
						)

					case let .caseStudy(caseStudy):
						Detail(caseStudy: caseStudy, recordEntry: self.recordEntry)

					case let .navigationLevel(level):
						CaseStudyNavigationStack.LevelView(
							level: level,
							recordEntry: self.recordNavigationStackEntry,
							nextDestination: CompactRoute.navigationLevel
						)
					}
				}
		}
	}

	private func recordNavigationStackEntry(_ entry: TimelineEntry) -> Void {
		self.recordEntry(.navigationStack, entry)
	}
}

private enum CompactRoute: Hashable {
	case caseStudy(CaseStudy)
	case navigationLevel(CaseStudyNavigationStack.Level)
}

struct RegularRootView: View {
	let recordEntry: LifecycleSessionRecorder

	@State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn

	var body: some View {
		NavigationSplitView(columnVisibility: self.$columnVisibility) {
			Sidebar()
				.navigationDestination(for: CaseStudy.self) { caseStudy in
					RegularDetail(
						caseStudy: caseStudy,
						recordEntry: self.recordEntry
					)
				}
		} detail: {
			Detail(caseStudy: nil, recordEntry: self.recordEntry)
		}
	}
}

struct Sidebar<Destination: Hashable>: View {
	let destination: (CaseStudy) -> Destination

	@Environment(\.lifecycleSessionBottomScrollContentMargin) private var bottomScrollContentMargin

	var body: some View {
		List {
			ForEach(CaseStudyCategory.all) { category in
				Section {
					ForEach(category.caseStudies) { caseStudy in
						NavigationLink(value: self.destination(caseStudy)) {
							CaseStudyRow(caseStudy: caseStudy)
						}
					}
				} header: {
					Text(category.label)
				}
			}
		}
		.contentMargins(.bottom, self.bottomScrollContentMargin, for: .scrollContent)
		.navigationTitle("SwiftUI View Lifecycle")
	}
}

extension Sidebar where Destination == CaseStudy {
	init() {
		self.destination = { $0 }
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
	let recordEntry: LifecycleSessionRecorder

	var body: some View {
		Group {
			if let caseStudy = self.caseStudy {
				MainContent(
					caseStudy: caseStudy,
					recordEntry: self.recordEntry
				)
			}
			else {
				Text("Select a case study.")
			}
		}
		.navigationTitle(self.caseStudy?.label ?? "")
	}
}

struct RegularDetail: View {
	let caseStudy: CaseStudy
	let recordEntry: LifecycleSessionRecorder

	var body: some View {
		switch self.caseStudy {
		case .navigationStack:
			CaseStudyNavigationStack(recordEntry: self.recordCurrentCaseStudyEntry)
				.navigationTitle(self.caseStudy.label)

		default:
			Detail(
				caseStudy: self.caseStudy,
				recordEntry: self.recordEntry
			)
		}
	}

	private func recordCurrentCaseStudyEntry(_ entry: TimelineEntry) -> Void {
		self.recordEntry(self.caseStudy, entry)
	}
}

struct MainContent: View {
	var caseStudy: CaseStudy
	let recordEntry: LifecycleSessionRecorder

	var body: some View {
		switch self.caseStudy {
		case .ifElse:
			CaseStudyIfElse(recordEntry: self.recordCurrentCaseStudyEntry)

		case .switch:
			CaseStudySwitch(recordEntry: self.recordCurrentCaseStudyEntry)

		case .id:
			CaseStudyIDModifier(recordEntry: self.recordCurrentCaseStudyEntry)

		case .opacity:
			CaseStudyOpacity(recordEntry: self.recordCurrentCaseStudyEntry)

		case .ifTransition:
			CaseStudyIfTransition(recordEntry: self.recordCurrentCaseStudyEntry)

		case .scrollViewStatic:
			CaseStudyScrollViewStatic(recordEntry: self.recordCurrentCaseStudyEntry)

		case .scrollViewDynamic:
			CaseStudyScrollViewDynamic(recordEntry: self.recordCurrentCaseStudyEntry)

		case .listDynamic:
			CaseStudyListDynamic(recordEntry: self.recordCurrentCaseStudyEntry)

		case .listStatic:
			CaseStudyListStatic(recordEntry: self.recordCurrentCaseStudyEntry)

		case .lazyVStack:
			CaseStudyLazyVStack(recordEntry: self.recordCurrentCaseStudyEntry)

		case .lazyVGrid:
			CaseStudyLazyVGrid(recordEntry: self.recordCurrentCaseStudyEntry)

		case .navigationStack:
			CaseStudyNavigationStack(recordEntry: self.recordCurrentCaseStudyEntry)

		case .tabView:
			CaseStudyTabView(recordEntry: self.recordCurrentCaseStudyEntry)
		}
	}

	private func recordCurrentCaseStudyEntry(_ entry: TimelineEntry) -> Void {
		self.recordEntry(self.caseStudy, entry)
	}
}

#Preview {
	RootView()
}
