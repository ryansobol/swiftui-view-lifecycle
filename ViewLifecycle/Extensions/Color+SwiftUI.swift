import SwiftUI

// MARK: - Color.Adjustment

extension Color {
	/// A color adjustment for one scale step.
	///
	/// `target` is the color mixed into the source color, and `amount` is the
	/// fraction of that target used by ``Shade/resolve(in:)``.
	struct Adjustment {
		/// The color mixed into the source color.
		let target: Color

		/// The fraction of `target` used in the mix.
		let amount: Double
	}
}

// MARK: - Color.Tone

extension Color {
	/// A tone used to select a scale adjustment.
	///
	/// Tone lets a shade use a scale that fits the source color.
	enum Tone {
		/// Use a chromatic tonal scale.
		case chromatic

		/// Use a neutral tonal scale.
		case neutral
	}
}

// MARK: - Color.Step

extension Color {
	/// A step on a Tailwind-inspired color scale.
	///
	/// `_50` is the lightest step, `_500` is the source color step, and `_950`
	/// is the darkest step. `Shade.resolve(in:)` applies inversion in dark mode
	/// so generated shade names such as `.blue50` keep their relative contrast
	/// across color schemes. Case names use a leading underscore because Swift
	/// identifiers cannot start with a digit.
	///
	/// - SeeAlso: [Tailwind CSS colors](https://tailwindcss.com/docs/colors)
	enum Step: CaseIterable {
		case _50, _100, _200, _300, _400, _500, _600, _700, _800, _900, _950

		/// The display label for this step.
		var label: String {
			return switch self {
			case ._50: "50"
			case ._100: "100"
			case ._200: "200"
			case ._300: "300"
			case ._400: "400"
			case ._500: "500"
			case ._600: "600"
			case ._700: "700"
			case ._800: "800"
			case ._900: "900"
			case ._950: "950"
			}
		}

		/// Returns the adjustment for this step and tone.
		///
		/// Steps below `_500` adjust the source color toward white, steps above
		/// `_500` adjust it toward black, and `_500` leaves it unchanged. The
		/// amount depends on `tone`.
		///
		/// This method is `nonisolated` because ``ShapeStyle/resolve(in:)`` is
		/// nonisolated under strict Swift concurrency.
		///
		/// - Parameter tone: The tone used to select the adjustment.
		/// - Returns: The adjustment for this step and tone.
		nonisolated func adjustment(for tone: Tone) -> Adjustment {
			return switch tone {
			case .chromatic: self.chromaticAdjustment
			case .neutral: self.neutralAdjustment
			}
		}

		/// The adjustment for chromatic colors at this step.
		///
		/// Chromatic adjustments preserve more source color near `_500` so
		/// adjacent steps remain saturated enough for hue-bearing palettes.
		nonisolated var chromaticAdjustment: Adjustment {
			return switch self {
			case ._50: .init(target: .white, amount: 0.87)
			case ._100: .init(target: .white, amount: 0.74)
			case ._200: .init(target: .white, amount: 0.58)
			case ._300: .init(target: .white, amount: 0.34)
			case ._400: .init(target: .white, amount: 0.14)
			case ._500: .init(target: .black, amount: 0.00)
			case ._600: .init(target: .black, amount: 0.12)
			case ._700: .init(target: .black, amount: 0.24)
			case ._800: .init(target: .black, amount: 0.44)
			case ._900: .init(target: .black, amount: 0.56)
			case ._950: .init(target: .black, amount: 0.68)
			}
		}

		/// The adjustment for neutral colors at this step.
		///
		/// Neutral adjustments move farther from `_500` so grayscale palettes
		/// provide stronger light and dark contrast.
		nonisolated var neutralAdjustment: Adjustment {
			return switch self {
			case ._50: .init(target: .white, amount: 0.90)
			case ._100: .init(target: .white, amount: 0.78)
			case ._200: .init(target: .white, amount: 0.60)
			case ._300: .init(target: .white, amount: 0.40)
			case ._400: .init(target: .white, amount: 0.20)
			case ._500: .init(target: .black, amount: 0.00)
			case ._600: .init(target: .black, amount: 0.18)
			case ._700: .init(target: .black, amount: 0.34)
			case ._800: .init(target: .black, amount: 0.50)
			case ._900: .init(target: .black, amount: 0.62)
			case ._950: .init(target: .black, amount: 0.72)
			}
		}

		/// The inversion of this step on the 50 through 950 scale.
		///
		/// Inversion maps a light-mode step to the matching dark-mode step. For
		/// example, `_50` inverts to `_950`, and `_500` inverts to itself.
		///
		/// This property is `nonisolated` because ``ShapeStyle/resolve(in:)`` is
		/// nonisolated under strict Swift concurrency.
		///
		/// - Returns: The inverted step.
		nonisolated var inverted: Step {
			return switch self {
			case ._50: ._950
			case ._100: ._900
			case ._200: ._800
			case ._300: ._700
			case ._400: ._600
			case ._500: ._500
			case ._600: ._400
			case ._700: ._300
			case ._800: ._200
			case ._900: ._100
			case ._950: ._50
			}
		}
	}
}

// MARK: - Color.Shade

extension Color {
	/// A shape style that renders a shade for a specific color scale step.
	///
	/// `Shade` combines a source color, step, and tone. At render time,
	/// ``resolve(in:)`` applies inversion when needed, then applies the
	/// matching adjustment.
	struct Shade: ShapeStyle {
		/// The source color used to resolve the shade.
		let base: Color

		/// The step used to resolve the shade.
		let step: Step

		/// The tone used to resolve the shade.
		let tone: Tone

		/// Resolves the shade for one SwiftUI render pass.
		///
		/// The environment's color scheme determines whether `step` is inverted
		/// before the adjustment for `tone` is applied to `base` in SwiftUI's
		/// perceptual color space.
		///
		/// - Parameter environment: The SwiftUI environment values for this render pass.
		/// - Returns: A shape style for the resolved shade.
		func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
			let effectiveStep = environment.colorScheme == .dark ? self.step.inverted : self.step
			let adjustment = effectiveStep.adjustment(for: self.tone)

			return self.base.mix(with: adjustment.target, by: adjustment.amount, in: .perceptual)
		}
	}
}

// MARK: - Color.shade(_:)

extension Color {
	/// Creates a shade of this color for the specified step.
	///
	/// Generated static properties such as `.blue50` and `.pink900` use this
	/// helper to pair each source color with the step and tone used in light mode.
	///
	/// - Parameter step: The step used to resolve the shade in light mode.
	/// - Parameter tone: The tone used to resolve the shade.
	/// - Returns: A shade that uses the inverted step in dark mode.
	func shade(_ step: Step, tone: Tone = .chromatic) -> Shade {
		return Shade(base: self, step: step, tone: tone)
	}
}

// MARK: - Static color shades

extension Color {
	// MARK: Red

	/// A Tailwind-inspired red shade that uses step 50 in light mode and step 950 in dark mode.
	static var red50: Shade { Color.red.shade(._50) }
	/// A Tailwind-inspired red shade that uses step 100 in light mode and step 900 in dark mode.
	static var red100: Shade { Color.red.shade(._100) }
	/// A Tailwind-inspired red shade that uses step 200 in light mode and step 800 in dark mode.
	static var red200: Shade { Color.red.shade(._200) }
	/// A Tailwind-inspired red shade that uses step 300 in light mode and step 700 in dark mode.
	static var red300: Shade { Color.red.shade(._300) }
	/// A Tailwind-inspired red shade that uses step 400 in light mode and step 600 in dark mode.
	static var red400: Shade { Color.red.shade(._400) }
	/// A Tailwind-inspired red shade that uses step 500 in light mode and step 500 in dark mode.
	static var red500: Shade { Color.red.shade(._500) }
	/// A Tailwind-inspired red shade that uses step 600 in light mode and step 400 in dark mode.
	static var red600: Shade { Color.red.shade(._600) }
	/// A Tailwind-inspired red shade that uses step 700 in light mode and step 300 in dark mode.
	static var red700: Shade { Color.red.shade(._700) }
	/// A Tailwind-inspired red shade that uses step 800 in light mode and step 200 in dark mode.
	static var red800: Shade { Color.red.shade(._800) }
	/// A Tailwind-inspired red shade that uses step 900 in light mode and step 100 in dark mode.
	static var red900: Shade { Color.red.shade(._900) }
	/// A Tailwind-inspired red shade that uses step 950 in light mode and step 50 in dark mode.
	static var red950: Shade { Color.red.shade(._950) }

	// MARK: Orange

	/// A Tailwind-inspired orange shade that uses step 50 in light mode and step 950 in dark mode.
	static var orange50: Shade { Color.orange.shade(._50) }
	/// A Tailwind-inspired orange shade that uses step 100 in light mode and step 900 in dark mode.
	static var orange100: Shade { Color.orange.shade(._100) }
	/// A Tailwind-inspired orange shade that uses step 200 in light mode and step 800 in dark mode.
	static var orange200: Shade { Color.orange.shade(._200) }
	/// A Tailwind-inspired orange shade that uses step 300 in light mode and step 700 in dark mode.
	static var orange300: Shade { Color.orange.shade(._300) }
	/// A Tailwind-inspired orange shade that uses step 400 in light mode and step 600 in dark mode.
	static var orange400: Shade { Color.orange.shade(._400) }
	/// A Tailwind-inspired orange shade that uses step 500 in light mode and step 500 in dark mode.
	static var orange500: Shade { Color.orange.shade(._500) }
	/// A Tailwind-inspired orange shade that uses step 600 in light mode and step 400 in dark mode.
	static var orange600: Shade { Color.orange.shade(._600) }
	/// A Tailwind-inspired orange shade that uses step 700 in light mode and step 300 in dark mode.
	static var orange700: Shade { Color.orange.shade(._700) }
	/// A Tailwind-inspired orange shade that uses step 800 in light mode and step 200 in dark mode.
	static var orange800: Shade { Color.orange.shade(._800) }
	/// A Tailwind-inspired orange shade that uses step 900 in light mode and step 100 in dark mode.
	static var orange900: Shade { Color.orange.shade(._900) }
	/// A Tailwind-inspired orange shade that uses step 950 in light mode and step 50 in dark mode.
	static var orange950: Shade { Color.orange.shade(._950) }

	// MARK: Yellow

	/// A Tailwind-inspired yellow shade that uses step 50 in light mode and step 950 in dark mode.
	static var yellow50: Shade { Color.yellow.shade(._50) }
	/// A Tailwind-inspired yellow shade that uses step 100 in light mode and step 900 in dark mode.
	static var yellow100: Shade { Color.yellow.shade(._100) }
	/// A Tailwind-inspired yellow shade that uses step 200 in light mode and step 800 in dark mode.
	static var yellow200: Shade { Color.yellow.shade(._200) }
	/// A Tailwind-inspired yellow shade that uses step 300 in light mode and step 700 in dark mode.
	static var yellow300: Shade { Color.yellow.shade(._300) }
	/// A Tailwind-inspired yellow shade that uses step 400 in light mode and step 600 in dark mode.
	static var yellow400: Shade { Color.yellow.shade(._400) }
	/// A Tailwind-inspired yellow shade that uses step 500 in light mode and step 500 in dark mode.
	static var yellow500: Shade { Color.yellow.shade(._500) }
	/// A Tailwind-inspired yellow shade that uses step 600 in light mode and step 400 in dark mode.
	static var yellow600: Shade { Color.yellow.shade(._600) }
	/// A Tailwind-inspired yellow shade that uses step 700 in light mode and step 300 in dark mode.
	static var yellow700: Shade { Color.yellow.shade(._700) }
	/// A Tailwind-inspired yellow shade that uses step 800 in light mode and step 200 in dark mode.
	static var yellow800: Shade { Color.yellow.shade(._800) }
	/// A Tailwind-inspired yellow shade that uses step 900 in light mode and step 100 in dark mode.
	static var yellow900: Shade { Color.yellow.shade(._900) }
	/// A Tailwind-inspired yellow shade that uses step 950 in light mode and step 50 in dark mode.
	static var yellow950: Shade { Color.yellow.shade(._950) }

	// MARK: Green

	/// A Tailwind-inspired green shade that uses step 50 in light mode and step 950 in dark mode.
	static var green50: Shade { Color.green.shade(._50) }
	/// A Tailwind-inspired green shade that uses step 100 in light mode and step 900 in dark mode.
	static var green100: Shade { Color.green.shade(._100) }
	/// A Tailwind-inspired green shade that uses step 200 in light mode and step 800 in dark mode.
	static var green200: Shade { Color.green.shade(._200) }
	/// A Tailwind-inspired green shade that uses step 300 in light mode and step 700 in dark mode.
	static var green300: Shade { Color.green.shade(._300) }
	/// A Tailwind-inspired green shade that uses step 400 in light mode and step 600 in dark mode.
	static var green400: Shade { Color.green.shade(._400) }
	/// A Tailwind-inspired green shade that uses step 500 in light mode and step 500 in dark mode.
	static var green500: Shade { Color.green.shade(._500) }
	/// A Tailwind-inspired green shade that uses step 600 in light mode and step 400 in dark mode.
	static var green600: Shade { Color.green.shade(._600) }
	/// A Tailwind-inspired green shade that uses step 700 in light mode and step 300 in dark mode.
	static var green700: Shade { Color.green.shade(._700) }
	/// A Tailwind-inspired green shade that uses step 800 in light mode and step 200 in dark mode.
	static var green800: Shade { Color.green.shade(._800) }
	/// A Tailwind-inspired green shade that uses step 900 in light mode and step 100 in dark mode.
	static var green900: Shade { Color.green.shade(._900) }
	/// A Tailwind-inspired green shade that uses step 950 in light mode and step 50 in dark mode.
	static var green950: Shade { Color.green.shade(._950) }

	// MARK: Mint

	/// A Tailwind-inspired mint shade that uses step 50 in light mode and step 950 in dark mode.
	static var mint50: Shade { Color.mint.shade(._50) }
	/// A Tailwind-inspired mint shade that uses step 100 in light mode and step 900 in dark mode.
	static var mint100: Shade { Color.mint.shade(._100) }
	/// A Tailwind-inspired mint shade that uses step 200 in light mode and step 800 in dark mode.
	static var mint200: Shade { Color.mint.shade(._200) }
	/// A Tailwind-inspired mint shade that uses step 300 in light mode and step 700 in dark mode.
	static var mint300: Shade { Color.mint.shade(._300) }
	/// A Tailwind-inspired mint shade that uses step 400 in light mode and step 600 in dark mode.
	static var mint400: Shade { Color.mint.shade(._400) }
	/// A Tailwind-inspired mint shade that uses step 500 in light mode and step 500 in dark mode.
	static var mint500: Shade { Color.mint.shade(._500) }
	/// A Tailwind-inspired mint shade that uses step 600 in light mode and step 400 in dark mode.
	static var mint600: Shade { Color.mint.shade(._600) }
	/// A Tailwind-inspired mint shade that uses step 700 in light mode and step 300 in dark mode.
	static var mint700: Shade { Color.mint.shade(._700) }
	/// A Tailwind-inspired mint shade that uses step 800 in light mode and step 200 in dark mode.
	static var mint800: Shade { Color.mint.shade(._800) }
	/// A Tailwind-inspired mint shade that uses step 900 in light mode and step 100 in dark mode.
	static var mint900: Shade { Color.mint.shade(._900) }
	/// A Tailwind-inspired mint shade that uses step 950 in light mode and step 50 in dark mode.
	static var mint950: Shade { Color.mint.shade(._950) }

	// MARK: Teal

	/// A Tailwind-inspired teal shade that uses step 50 in light mode and step 950 in dark mode.
	static var teal50: Shade { Color.teal.shade(._50) }
	/// A Tailwind-inspired teal shade that uses step 100 in light mode and step 900 in dark mode.
	static var teal100: Shade { Color.teal.shade(._100) }
	/// A Tailwind-inspired teal shade that uses step 200 in light mode and step 800 in dark mode.
	static var teal200: Shade { Color.teal.shade(._200) }
	/// A Tailwind-inspired teal shade that uses step 300 in light mode and step 700 in dark mode.
	static var teal300: Shade { Color.teal.shade(._300) }
	/// A Tailwind-inspired teal shade that uses step 400 in light mode and step 600 in dark mode.
	static var teal400: Shade { Color.teal.shade(._400) }
	/// A Tailwind-inspired teal shade that uses step 500 in light mode and step 500 in dark mode.
	static var teal500: Shade { Color.teal.shade(._500) }
	/// A Tailwind-inspired teal shade that uses step 600 in light mode and step 400 in dark mode.
	static var teal600: Shade { Color.teal.shade(._600) }
	/// A Tailwind-inspired teal shade that uses step 700 in light mode and step 300 in dark mode.
	static var teal700: Shade { Color.teal.shade(._700) }
	/// A Tailwind-inspired teal shade that uses step 800 in light mode and step 200 in dark mode.
	static var teal800: Shade { Color.teal.shade(._800) }
	/// A Tailwind-inspired teal shade that uses step 900 in light mode and step 100 in dark mode.
	static var teal900: Shade { Color.teal.shade(._900) }
	/// A Tailwind-inspired teal shade that uses step 950 in light mode and step 50 in dark mode.
	static var teal950: Shade { Color.teal.shade(._950) }

	// MARK: Cyan

	/// A Tailwind-inspired cyan shade that uses step 50 in light mode and step 950 in dark mode.
	static var cyan50: Shade { Color.cyan.shade(._50) }
	/// A Tailwind-inspired cyan shade that uses step 100 in light mode and step 900 in dark mode.
	static var cyan100: Shade { Color.cyan.shade(._100) }
	/// A Tailwind-inspired cyan shade that uses step 200 in light mode and step 800 in dark mode.
	static var cyan200: Shade { Color.cyan.shade(._200) }
	/// A Tailwind-inspired cyan shade that uses step 300 in light mode and step 700 in dark mode.
	static var cyan300: Shade { Color.cyan.shade(._300) }
	/// A Tailwind-inspired cyan shade that uses step 400 in light mode and step 600 in dark mode.
	static var cyan400: Shade { Color.cyan.shade(._400) }
	/// A Tailwind-inspired cyan shade that uses step 500 in light mode and step 500 in dark mode.
	static var cyan500: Shade { Color.cyan.shade(._500) }
	/// A Tailwind-inspired cyan shade that uses step 600 in light mode and step 400 in dark mode.
	static var cyan600: Shade { Color.cyan.shade(._600) }
	/// A Tailwind-inspired cyan shade that uses step 700 in light mode and step 300 in dark mode.
	static var cyan700: Shade { Color.cyan.shade(._700) }
	/// A Tailwind-inspired cyan shade that uses step 800 in light mode and step 200 in dark mode.
	static var cyan800: Shade { Color.cyan.shade(._800) }
	/// A Tailwind-inspired cyan shade that uses step 900 in light mode and step 100 in dark mode.
	static var cyan900: Shade { Color.cyan.shade(._900) }
	/// A Tailwind-inspired cyan shade that uses step 950 in light mode and step 50 in dark mode.
	static var cyan950: Shade { Color.cyan.shade(._950) }

	// MARK: Blue

	/// A Tailwind-inspired blue shade that uses step 50 in light mode and step 950 in dark mode.
	static var blue50: Shade { Color.blue.shade(._50) }
	/// A Tailwind-inspired blue shade that uses step 100 in light mode and step 900 in dark mode.
	static var blue100: Shade { Color.blue.shade(._100) }
	/// A Tailwind-inspired blue shade that uses step 200 in light mode and step 800 in dark mode.
	static var blue200: Shade { Color.blue.shade(._200) }
	/// A Tailwind-inspired blue shade that uses step 300 in light mode and step 700 in dark mode.
	static var blue300: Shade { Color.blue.shade(._300) }
	/// A Tailwind-inspired blue shade that uses step 400 in light mode and step 600 in dark mode.
	static var blue400: Shade { Color.blue.shade(._400) }
	/// A Tailwind-inspired blue shade that uses step 500 in light mode and step 500 in dark mode.
	static var blue500: Shade { Color.blue.shade(._500) }
	/// A Tailwind-inspired blue shade that uses step 600 in light mode and step 400 in dark mode.
	static var blue600: Shade { Color.blue.shade(._600) }
	/// A Tailwind-inspired blue shade that uses step 700 in light mode and step 300 in dark mode.
	static var blue700: Shade { Color.blue.shade(._700) }
	/// A Tailwind-inspired blue shade that uses step 800 in light mode and step 200 in dark mode.
	static var blue800: Shade { Color.blue.shade(._800) }
	/// A Tailwind-inspired blue shade that uses step 900 in light mode and step 100 in dark mode.
	static var blue900: Shade { Color.blue.shade(._900) }
	/// A Tailwind-inspired blue shade that uses step 950 in light mode and step 50 in dark mode.
	static var blue950: Shade { Color.blue.shade(._950) }

	// MARK: Indigo

	/// A Tailwind-inspired indigo shade that uses step 50 in light mode and step 950 in dark mode.
	static var indigo50: Shade { Color.indigo.shade(._50) }
	/// A Tailwind-inspired indigo shade that uses step 100 in light mode and step 900 in dark mode.
	static var indigo100: Shade { Color.indigo.shade(._100) }
	/// A Tailwind-inspired indigo shade that uses step 200 in light mode and step 800 in dark mode.
	static var indigo200: Shade { Color.indigo.shade(._200) }
	/// A Tailwind-inspired indigo shade that uses step 300 in light mode and step 700 in dark mode.
	static var indigo300: Shade { Color.indigo.shade(._300) }
	/// A Tailwind-inspired indigo shade that uses step 400 in light mode and step 600 in dark mode.
	static var indigo400: Shade { Color.indigo.shade(._400) }
	/// A Tailwind-inspired indigo shade that uses step 500 in light mode and step 500 in dark mode.
	static var indigo500: Shade { Color.indigo.shade(._500) }
	/// A Tailwind-inspired indigo shade that uses step 600 in light mode and step 400 in dark mode.
	static var indigo600: Shade { Color.indigo.shade(._600) }
	/// A Tailwind-inspired indigo shade that uses step 700 in light mode and step 300 in dark mode.
	static var indigo700: Shade { Color.indigo.shade(._700) }
	/// A Tailwind-inspired indigo shade that uses step 800 in light mode and step 200 in dark mode.
	static var indigo800: Shade { Color.indigo.shade(._800) }
	/// A Tailwind-inspired indigo shade that uses step 900 in light mode and step 100 in dark mode.
	static var indigo900: Shade { Color.indigo.shade(._900) }
	/// A Tailwind-inspired indigo shade that uses step 950 in light mode and step 50 in dark mode.
	static var indigo950: Shade { Color.indigo.shade(._950) }

	// MARK: Purple

	/// A Tailwind-inspired purple shade that uses step 50 in light mode and step 950 in dark mode.
	static var purple50: Shade { Color.purple.shade(._50) }
	/// A Tailwind-inspired purple shade that uses step 100 in light mode and step 900 in dark mode.
	static var purple100: Shade { Color.purple.shade(._100) }
	/// A Tailwind-inspired purple shade that uses step 200 in light mode and step 800 in dark mode.
	static var purple200: Shade { Color.purple.shade(._200) }
	/// A Tailwind-inspired purple shade that uses step 300 in light mode and step 700 in dark mode.
	static var purple300: Shade { Color.purple.shade(._300) }
	/// A Tailwind-inspired purple shade that uses step 400 in light mode and step 600 in dark mode.
	static var purple400: Shade { Color.purple.shade(._400) }
	/// A Tailwind-inspired purple shade that uses step 500 in light mode and step 500 in dark mode.
	static var purple500: Shade { Color.purple.shade(._500) }
	/// A Tailwind-inspired purple shade that uses step 600 in light mode and step 400 in dark mode.
	static var purple600: Shade { Color.purple.shade(._600) }
	/// A Tailwind-inspired purple shade that uses step 700 in light mode and step 300 in dark mode.
	static var purple700: Shade { Color.purple.shade(._700) }
	/// A Tailwind-inspired purple shade that uses step 800 in light mode and step 200 in dark mode.
	static var purple800: Shade { Color.purple.shade(._800) }
	/// A Tailwind-inspired purple shade that uses step 900 in light mode and step 100 in dark mode.
	static var purple900: Shade { Color.purple.shade(._900) }
	/// A Tailwind-inspired purple shade that uses step 950 in light mode and step 50 in dark mode.
	static var purple950: Shade { Color.purple.shade(._950) }

	// MARK: Pink

	/// A Tailwind-inspired pink shade that uses step 50 in light mode and step 950 in dark mode.
	static var pink50: Shade { Color.pink.shade(._50) }
	/// A Tailwind-inspired pink shade that uses step 100 in light mode and step 900 in dark mode.
	static var pink100: Shade { Color.pink.shade(._100) }
	/// A Tailwind-inspired pink shade that uses step 200 in light mode and step 800 in dark mode.
	static var pink200: Shade { Color.pink.shade(._200) }
	/// A Tailwind-inspired pink shade that uses step 300 in light mode and step 700 in dark mode.
	static var pink300: Shade { Color.pink.shade(._300) }
	/// A Tailwind-inspired pink shade that uses step 400 in light mode and step 600 in dark mode.
	static var pink400: Shade { Color.pink.shade(._400) }
	/// A Tailwind-inspired pink shade that uses step 500 in light mode and step 500 in dark mode.
	static var pink500: Shade { Color.pink.shade(._500) }
	/// A Tailwind-inspired pink shade that uses step 600 in light mode and step 400 in dark mode.
	static var pink600: Shade { Color.pink.shade(._600) }
	/// A Tailwind-inspired pink shade that uses step 700 in light mode and step 300 in dark mode.
	static var pink700: Shade { Color.pink.shade(._700) }
	/// A Tailwind-inspired pink shade that uses step 800 in light mode and step 200 in dark mode.
	static var pink800: Shade { Color.pink.shade(._800) }
	/// A Tailwind-inspired pink shade that uses step 900 in light mode and step 100 in dark mode.
	static var pink900: Shade { Color.pink.shade(._900) }
	/// A Tailwind-inspired pink shade that uses step 950 in light mode and step 50 in dark mode.
	static var pink950: Shade { Color.pink.shade(._950) }

	// MARK: Brown

	/// A Tailwind-inspired brown shade that uses step 50 in light mode and step 950 in dark mode.
	static var brown50: Shade { Color.brown.shade(._50) }
	/// A Tailwind-inspired brown shade that uses step 100 in light mode and step 900 in dark mode.
	static var brown100: Shade { Color.brown.shade(._100) }
	/// A Tailwind-inspired brown shade that uses step 200 in light mode and step 800 in dark mode.
	static var brown200: Shade { Color.brown.shade(._200) }
	/// A Tailwind-inspired brown shade that uses step 300 in light mode and step 700 in dark mode.
	static var brown300: Shade { Color.brown.shade(._300) }
	/// A Tailwind-inspired brown shade that uses step 400 in light mode and step 600 in dark mode.
	static var brown400: Shade { Color.brown.shade(._400) }
	/// A Tailwind-inspired brown shade that uses step 500 in light mode and step 500 in dark mode.
	static var brown500: Shade { Color.brown.shade(._500) }
	/// A Tailwind-inspired brown shade that uses step 600 in light mode and step 400 in dark mode.
	static var brown600: Shade { Color.brown.shade(._600) }
	/// A Tailwind-inspired brown shade that uses step 700 in light mode and step 300 in dark mode.
	static var brown700: Shade { Color.brown.shade(._700) }
	/// A Tailwind-inspired brown shade that uses step 800 in light mode and step 200 in dark mode.
	static var brown800: Shade { Color.brown.shade(._800) }
	/// A Tailwind-inspired brown shade that uses step 900 in light mode and step 100 in dark mode.
	static var brown900: Shade { Color.brown.shade(._900) }
	/// A Tailwind-inspired brown shade that uses step 950 in light mode and step 50 in dark mode.
	static var brown950: Shade { Color.brown.shade(._950) }

	// MARK: Gray

	/// A Tailwind-inspired gray shade that uses step 50 in light mode and step 950 in dark mode.
	static var gray50: Shade { Color.gray.shade(._50, tone: .neutral) }
	/// A Tailwind-inspired gray shade that uses step 100 in light mode and step 900 in dark mode.
	static var gray100: Shade { Color.gray.shade(._100, tone: .neutral) }
	/// A Tailwind-inspired gray shade that uses step 200 in light mode and step 800 in dark mode.
	static var gray200: Shade { Color.gray.shade(._200, tone: .neutral) }
	/// A Tailwind-inspired gray shade that uses step 300 in light mode and step 700 in dark mode.
	static var gray300: Shade { Color.gray.shade(._300, tone: .neutral) }
	/// A Tailwind-inspired gray shade that uses step 400 in light mode and step 600 in dark mode.
	static var gray400: Shade { Color.gray.shade(._400, tone: .neutral) }
	/// A Tailwind-inspired gray shade that uses step 500 in light mode and step 500 in dark mode.
	static var gray500: Shade { Color.gray.shade(._500, tone: .neutral) }
	/// A Tailwind-inspired gray shade that uses step 600 in light mode and step 400 in dark mode.
	static var gray600: Shade { Color.gray.shade(._600, tone: .neutral) }
	/// A Tailwind-inspired gray shade that uses step 700 in light mode and step 300 in dark mode.
	static var gray700: Shade { Color.gray.shade(._700, tone: .neutral) }
	/// A Tailwind-inspired gray shade that uses step 800 in light mode and step 200 in dark mode.
	static var gray800: Shade { Color.gray.shade(._800, tone: .neutral) }
	/// A Tailwind-inspired gray shade that uses step 900 in light mode and step 100 in dark mode.
	static var gray900: Shade { Color.gray.shade(._900, tone: .neutral) }
	/// A Tailwind-inspired gray shade that uses step 950 in light mode and step 50 in dark mode.
	static var gray950: Shade { Color.gray.shade(._950, tone: .neutral) }
}
