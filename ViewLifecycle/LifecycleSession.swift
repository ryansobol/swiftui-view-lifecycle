import OSLog
import SwiftUI

typealias LifecycleSessionRecorder = (_ caseStudy: CaseStudy, _ entry: TimelineEntry) -> Void

private let eventLogInsetHeight: CGFloat = 252
private let bottomScrollContentMargin = eventLogInsetHeight + 16

private struct LifecycleSessionBottomScrollContentMarginKey: EnvironmentKey {
	static let defaultValue: CGFloat = 0
}

private struct LifecycleSessionEventLogInsetHeightKey: EnvironmentKey {
	static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
	var lifecycleSessionBottomScrollContentMargin: CGFloat {
		get { self[LifecycleSessionBottomScrollContentMarginKey.self] }
		set { self[LifecycleSessionBottomScrollContentMarginKey.self] = newValue }
	}

	var lifecycleSessionEventLogInsetHeight: CGFloat {
		get { self[LifecycleSessionEventLogInsetHeightKey.self] }
		set { self[LifecycleSessionEventLogInsetHeightKey.self] = newValue }
	}
}

struct LifecycleSession<Content: View>: View {
	@ViewBuilder let content: (_ recordEntry: @escaping LifecycleSessionRecorder) -> Content

	@State private var entries = [TimelineEntry]()

	var body: some View {
		self.content { caseStudy, entry in
			self.recordEntry(caseStudy: caseStudy, entry: entry)
		}
		.environment(
			\.lifecycleSessionBottomScrollContentMargin,
			bottomScrollContentMargin
		)
		.environment(
			\.lifecycleSessionEventLogInsetHeight,
			eventLogInsetHeight
		)
		.safeAreaInset(edge: .bottom) {
			EventLog(entries: self.$entries)
				.frame(maxWidth: .infinity)
				.frame(height: eventLogInsetHeight)
				.background {
					ConcentricRectangle(
						uniformTopCorners: .concentric,
						uniformBottomCorners: .fixed(0)
					)
					.fill(.regularMaterial)
					.ignoresSafeArea(edges: .bottom)
				}
				.containerShape(
					.rect(
						topLeadingRadius: 24,
						bottomLeadingRadius: 0,
						bottomTrailingRadius: 0,
						topTrailingRadius: 24
					)
				)
		}
	}

	private func recordEntry(
		caseStudy: CaseStudy,
		entry: TimelineEntry
	) -> Void {
		#if DEBUG
			print("\(entry.timestamp) \(entry.event.label)")
		#else
			Logger.caseStudy(caseStudy).info("\(entry.event.label, privacy: .public)")
		#endif

		self.entries.append(entry)
	}
}

#Preview {
	LifecycleSession { recordEntry in
		VStack {
			Button("Record") {
				recordEntry(.ifElse, TimelineEntry(event: .action(.tapped("Preview"))))
			}
			.buttonStyle(.glassProminent)

			Spacer()
		}
		.padding()
	}
}
