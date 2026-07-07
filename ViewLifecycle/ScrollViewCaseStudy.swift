import Foundation
import SwiftUI

struct ScrollViewCaseStudy<Content: View>: View {
	let explanation: String
	@Binding var entries: [TimelineEntry]
	let isEventLogClearable: Bool
	@ViewBuilder let content: () -> Content

	var body: some View {
		ScrollView {
			VStack(spacing: 16) {
				Text(try! AttributedString(markdown: self.explanation))
					.font(.callout)
					.fixedSize(horizontal: false, vertical: true)
					.frame(maxWidth: .infinity, alignment: .leading)

				self.content()
			}
			.padding()
		}
		.safeAreaInset(edge: .bottom) {
			EventLog(
				entries: self.$entries,
				isShowingClearButton: self.isEventLogClearable
			)
			.frame(height: 220)
			.padding()
			.background(.regularMaterial)
		}
	}
}
