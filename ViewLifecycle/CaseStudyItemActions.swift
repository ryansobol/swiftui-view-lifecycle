import SwiftUI

struct CaseStudyItemActions: View {
	let prepend: () -> Void
	let append: () -> Void

	var body: some View {
		HStack {
			Button {
				self.prepend()
			} label: {
				Self.buttonLabel("Prepend", systemImage: "text.insert")
			}
			.buttonStyle(.glass)
			.controlSize(.large)
			.font(.body.weight(.medium))

			Spacer()

			Button {
				self.append()
			} label: {
				Self.buttonLabel("Append", systemImage: "text.append")
			}
			.buttonStyle(.glass)
			.controlSize(.large)
			.font(.body.weight(.medium))
		}
		.alignmentGuide(.listRowSeparatorLeading) { dimensions in
			dimensions[.leading]
		}
		.alignmentGuide(.listRowSeparatorTrailing) { dimensions in
			dimensions[.trailing]
		}
	}

	private static func buttonLabel(_ title: String, systemImage: String) -> some View {
		Label {
			Text(title)
				.foregroundStyle(.primary)
		} icon: {
			Image(systemName: systemImage)
				.foregroundStyle(.primary)
		}
	}
}

#Preview {
	CaseStudyItemActions(
		prepend: {},
		append: {}
	)
	.padding()
}
