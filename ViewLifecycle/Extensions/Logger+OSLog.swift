import Foundation
import OSLog

extension Logger {
	private static let subsystem = Bundle.main.bundleIdentifier ?? "ViewLifecycle"

	static let caseStudyIfElse = Logger(subsystem: Self.subsystem, category: "if/else")
	static let caseStudyIfTransition = Logger(subsystem: Self.subsystem, category: "if transition")
}
