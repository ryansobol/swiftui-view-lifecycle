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
			CompactSidebar(pushCaseStudy: self.pushCaseStudy)
				.navigationDestination(for: CompactRoute.self) { route in
					switch route {
					case .caseStudy(.navigationStack):
						CaseStudyNavigationStack.LevelView(
							level: .root,
							recordEntry: self.recordNavigationStackEntry,
							pushLevel: self.pushNavigationLevel
						)

					case let .caseStudy(caseStudy):
						Detail(caseStudy: caseStudy, recordEntry: self.recordEntry)

					case let .navigationLevel(level):
						CaseStudyNavigationStack.LevelView(
							level: level,
							recordEntry: self.recordNavigationStackEntry,
							pushLevel: self.pushNavigationLevel
						)
					}
				}
		}
		.onChange(of: self.path) { oldPath, newPath in
			self.recordPoppedRoutes(from: oldPath, to: newPath)
		}
	}

	private func pushCaseStudy(_ caseStudy: CaseStudy) -> Void {
		let route = CompactRoute.caseStudy(caseStudy)

		self.recordPushedRoute(route)
		self.path.append(route)
	}

	private func pushNavigationLevel(_ level: CaseStudyNavigationStack.Level) -> Void {
		let route = CompactRoute.navigationLevel(level)

		self.recordPushedRoute(route)
		self.path.append(route)
	}

	private func recordNavigationStackEntry(_ entry: TimelineEntry) -> Void {
		self.recordEntry(.navigationStack, entry)
	}

	private func recordPushedRoute(_ route: CompactRoute) -> Void {
		self.recordEntry(
			route.caseStudy,
			TimelineEntry(event: .action(.pushed(route.timelineLabel)))
		)
	}

	private func recordPoppedRoute(_ route: CompactRoute) -> Void {
		self.recordEntry(
			route.caseStudy,
			TimelineEntry(event: .action(.popped(route.timelineLabel)))
		)
	}

	private func recordPoppedRoutes(
		from oldPath: [CompactRoute],
		to newPath: [CompactRoute]
	) -> Void {
		guard oldPath.count > newPath.count else { return }

		for route in oldPath.dropFirst(newPath.count).reversed() {
			self.recordPoppedRoute(route)
		}
	}
}

private enum CompactRoute: Hashable {
	case caseStudy(CaseStudy)
	case navigationLevel(CaseStudyNavigationStack.Level)

	var caseStudy: CaseStudy {
		return switch self {
		case let .caseStudy(caseStudy): caseStudy
		case .navigationLevel: .navigationStack
		}
	}

	var timelineLabel: String {
		return switch self {
		case .caseStudy(.navigationStack): CaseStudyNavigationStack.Level.root.monitorLabel
		case let .caseStudy(caseStudy): caseStudy.label
		case let .navigationLevel(level): level.monitorLabel
		}
	}
}

struct CompactSidebar: View {
	let pushCaseStudy: (CaseStudy) -> Void

	@Environment(\.lifecycleSessionBottomScrollContentMargin) private var bottomScrollContentMargin

	var body: some View {
		List {
			ForEach(CaseStudyCategory.all) { category in
				Section {
					ForEach(category.caseStudies) { caseStudy in
						Button {
							self.pushCaseStudy(caseStudy)
						} label: {
							HStack(spacing: 12) {
								CaseStudyRow(caseStudy: caseStudy)

								Spacer(minLength: 12)

								Image(systemName: "chevron.right")
									.font(.body.weight(.semibold))
									.foregroundStyle(.secondary)
									.accessibilityHidden(true)
							}
							.contentShape(.rect)
						}
						.buttonStyle(.plain)
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
		.navigationTitle(self.caseStudy?.navigationTitle ?? "")
	}
}

struct RegularDetail: View {
	let caseStudy: CaseStudy
	let recordEntry: LifecycleSessionRecorder

	var body: some View {
		switch self.caseStudy {
		case .navigationStack:
			CaseStudyNavigationStack(recordEntry: self.recordCurrentCaseStudyEntry)
				.navigationTitle(self.caseStudy.navigationTitle)

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

		case .vStack:
			CaseStudyVStack(recordEntry: self.recordCurrentCaseStudyEntry)

		case .list:
			CaseStudyList(recordEntry: self.recordCurrentCaseStudyEntry)

		case .lazyVStack:
			CaseStudyLazyVStack(recordEntry: self.recordCurrentCaseStudyEntry)

		case .lazyVGrid:
			CaseStudyLazyVGrid(recordEntry: self.recordCurrentCaseStudyEntry)

		case .navigationStack:
			CaseStudyNavigationStack(recordEntry: self.recordCurrentCaseStudyEntry)

		case .sheetIsPresented:
			CaseStudySheetIsPresented(recordEntry: self.recordCurrentCaseStudyEntry)

		case .sheetItem:
			CaseStudySheetItem(recordEntry: self.recordCurrentCaseStudyEntry)

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
