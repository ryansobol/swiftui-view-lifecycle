import SwiftUI

struct TimelineEntryAge: View {
	enum Style {
		case relative
		case standalone
	}

	let entry: TimelineEntry?
	let style: Style
	let placeholder: String

	init(entry: TimelineEntry?, style: Style = .standalone, placeholder: String = "never") {
		self.entry = entry
		self.style = style
		self.placeholder = placeholder
	}

	var body: some View {
		TimelineView(.periodic(from: .now, by: 1)) { timeline in
			Text(self.label(now: timeline.date))
				.monospacedDigit()
		}
	}

	private func label(now: Date) -> String {
		guard let entry = self.entry else {
			return self.placeholder
		}

		return Self.label(since: entry.timestamp, now: now, style: self.style)
	}

	private static func label(since start: Date, now: Date, style: Style) -> String {
		let timerLabel = Self.timerLabel(since: start, now: now)

		return switch style {
		case .relative: "\(timerLabel) ago"
		case .standalone: timerLabel
		}
	}

	private static func timerLabel(since start: Date, now: Date) -> String {
		let secondsPerMinute = 60
		let secondsPerHour = secondsPerMinute * 60
		let elapsedSeconds = max(0, Int(now.timeIntervalSince(start)))
		let hours = elapsedSeconds / secondsPerHour
		let minutes = elapsedSeconds / secondsPerMinute % secondsPerMinute
		let seconds = elapsedSeconds % secondsPerMinute

		return hours > 0
			? "\(hours):\(Self.padded(minutes)):\(Self.padded(seconds))"
			: "\(minutes):\(Self.padded(seconds))"
	}

	private static func padded(_ value: Int) -> String {
		return value < 10 ? "0\(value)" : "\(value)"
	}
}
