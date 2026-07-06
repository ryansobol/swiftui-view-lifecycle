import Foundation
import OSLog

extension Logger {
	private static let subsystem = Bundle.main.bundleIdentifier ?? "ViewLifecycle"

	static func caseStudy(_ caseStudy: CaseStudy) -> Logger {
		return Logger(subsystem: self.subsystem, category: caseStudy.logCategory)
	}
}
