import SwiftUI

struct CaseStudyExplanation: View {
	let text: String

	var body: some View {
		Text(try! AttributedString(markdown: self.text))
			.font(.callout)
			.fixedSize(horizontal: false, vertical: true)
	}
}
