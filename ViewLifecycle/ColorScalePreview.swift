import SwiftUI

struct ColorScalePreview: View {
	@Environment(\.colorScheme) private var colorScheme

	var body: some View {
		ScrollView([.horizontal, .vertical]) {
			VStack(alignment: .leading, spacing: 24) {
				Text(self.title)
					.font(.title.bold())

				Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 16) {
					ColorScaleHeader()

					ForEach(Self.scales) { scale in
						ColorScaleRow(scale: scale)
					}
				}
			}
			.foregroundStyle(.white)
			.padding(32)
		}
		.background(Color.black)
	}

	private var title: String {
		return switch self.colorScheme {
		case .dark: "Color Scale Preview: Dark"
		case .light: "Color Scale Preview: Light"
		@unknown default: "Color Scale Preview"
		}
	}

	private static let scales: [ColorScale] = [
		ColorScale(name: "Red", base: .red),
		ColorScale(name: "Orange", base: .orange),
		ColorScale(name: "Yellow", base: .yellow),
		ColorScale(name: "Green", base: .green),
		ColorScale(name: "Mint", base: .mint),
		ColorScale(name: "Teal", base: .teal),
		ColorScale(name: "Cyan", base: .cyan),
		ColorScale(name: "Blue", base: .blue),
		ColorScale(name: "Indigo", base: .indigo),
		ColorScale(name: "Purple", base: .purple),
		ColorScale(name: "Pink", base: .pink),
		ColorScale(name: "Brown", base: .brown),
		ColorScale(name: "Gray", base: .gray, tone: .neutral),
	]
}

private struct ColorScale: Identifiable {
	let name: String
	let base: Color
	let tone: Color.Tone

	init(name: String, base: Color, tone: Color.Tone = .chromatic) {
		self.name = name
		self.base = base
		self.tone = tone
	}

	var id: String {
		return self.name
	}

	var swatches: [Color.Shade] {
		return Color.Step.allCases.map { step in
			self.base.shade(step, tone: self.tone)
		}
	}
}

private struct ColorScaleHeader: View {
	var body: some View {
		GridRow {
			Color.clear
				.frame(width: 88, height: 1)

			ForEach(Color.Step.allCases, id: \.self) { step in
				Text(step.label)
					.font(.headline.monospacedDigit())
					.frame(width: 52)
			}
		}
	}
}

private struct ColorScaleRow: View {
	let scale: ColorScale

	var body: some View {
		GridRow {
			Text(self.scale.name)
				.font(.headline)
				.frame(width: 88, alignment: .leading)

			ForEach(Array(self.scale.swatches.enumerated()), id: \.offset) { _, swatch in
				ColorScaleSwatch(style: swatch)
			}
		}
	}
}

private struct ColorScaleSwatch: View {
	let style: Color.Shade

	var body: some View {
		RoundedRectangle(cornerRadius: 8)
			.fill(self.style)
			.frame(width: 52, height: 52)
			.overlay {
				RoundedRectangle(cornerRadius: 8)
					.stroke(.white.opacity(0.14), lineWidth: 1)
			}
	}
}

#Preview("Color Scale: Light") {
	ColorScalePreview()
		.preferredColorScheme(.light)
}

#Preview("Color Scale: Dark") {
	ColorScalePreview()
		.preferredColorScheme(.dark)
}
