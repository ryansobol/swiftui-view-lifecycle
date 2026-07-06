import SwiftUI

struct ElapsedTimerText: View {
	enum Style {
		case relative
		case standalone
	}

	let start: Date
	let style: Style

	init(since start: Date, style: Style = .standalone) {
		self.start = start
		self.style = style
	}

	var body: some View {
		TimelineView(.periodic(from: .now, by: 1)) { timeline in
			Text(Self.label(since: self.start, now: timeline.date, style: self.style))
				.monospacedDigit()
		}
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
