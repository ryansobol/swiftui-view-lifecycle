import SwiftUI

private let caseStudySwipeActionWidth: CGFloat = 116
private let caseStudySwipeMinimumDistance: CGFloat = 24
private let caseStudySwipeOpenThreshold: CGFloat = 44

private struct CaseStudyOpenSwipeActionIDKey: EnvironmentKey {
	static let defaultValue: Binding<UUID?> = .constant(nil)
}

private extension EnvironmentValues {
	var caseStudyOpenSwipeActionID: Binding<UUID?> {
		get { self[CaseStudyOpenSwipeActionIDKey.self] }
		set { self[CaseStudyOpenSwipeActionIDKey.self] = newValue }
	}
}

struct CaseStudySwipeActionButton<Label: View>: View {
	private let action: () -> Void
	private let label: () -> Label

	init(
		action: @escaping () -> Void,
		@ViewBuilder label: @escaping () -> Label
	) {
		self.action = action
		self.label = label
	}

	var body: some View {
		Button {
			self.action()
		} label: {
			VStack(spacing: 6) {
				self.label()
			}
			.font(.body)
			.foregroundStyle(.secondary)
			.labelStyle(CaseStudySwipeActionLabelStyle())
		}
		.buttonStyle(.plain)
	}
}

private struct CaseStudySwipeActionLabelStyle: LabelStyle {
	func makeBody(configuration: Configuration) -> some View {
		VStack(spacing: 6) {
			configuration.icon
				.font(.title2)
				.foregroundStyle(.white)
				.frame(width: 54, height: 54)
				.background(.red, in: Circle())

			configuration.title
				.font(.body)
				.foregroundStyle(.secondary)
		}
	}
}

private struct CaseStudySwipeActionsContainerModifier: ViewModifier {
	@State private var openActionID: UUID?

	func body(content: Content) -> some View {
		content
			.environment(\.caseStudyOpenSwipeActionID, self.$openActionID)
	}
}

private struct CaseStudySwipeActionsModifier<Actions: View>: ViewModifier {
	let actions: () -> Actions

	@Environment(\.caseStudyOpenSwipeActionID) private var openActionID
	@GestureState private var dragOffset: CGFloat = 0
	@State private var actionID = UUID()
	@State private var isOpen = false

	private var revealedWidth: CGFloat {
		let baseOffset = self.isOpen ? caseStudySwipeActionWidth : 0
		let proposedOffset = baseOffset - self.dragOffset

		return min(caseStudySwipeActionWidth, max(0, proposedOffset))
	}

	func body(content: Content) -> some View {
		ZStack(alignment: .trailing) {
			HStack {
				Spacer()

				self.actions()
					.frame(width: caseStudySwipeActionWidth)
					.opacity(self.revealedWidth > 0 ? 1 : 0)
					.allowsHitTesting(self.revealedWidth > 0)
			}
			.zIndex(0)

			content
				.frame(maxWidth: .infinity)
				.background(.background)
				.offset(x: -self.revealedWidth)
				.gesture(self.dragGesture)
				.zIndex(1)
		}
		.clipShape(Rectangle())
		.onChange(of: self.openActionID.wrappedValue) { _, openActionID in
			if openActionID != self.actionID {
				self.isOpen = false
			}
		}
		.animation(.snappy, value: self.isOpen)
		.animation(.snappy, value: self.openActionID.wrappedValue)
	}

	private func endDrag(translation: CGFloat) -> Void {
		let shouldOpen = -translation > caseStudySwipeOpenThreshold

		self.isOpen = shouldOpen
		self.openActionID.wrappedValue = shouldOpen ? self.actionID : nil
	}

	private var dragGesture: some Gesture {
		DragGesture(minimumDistance: caseStudySwipeMinimumDistance)
			.updating(self.$dragOffset) { value, state, _ in
				guard Self.isHorizontalDrag(value) else { return }

				state = value.translation.width
			}
			.onEnded { value in
				guard Self.isHorizontalDrag(value) else { return }

				self.endDrag(translation: value.translation.width)
			}
	}

	private static func isHorizontalDrag(_ value: DragGesture.Value) -> Bool {
		abs(value.translation.width) > abs(value.translation.height)
	}
}

extension View {
	func caseStudySwipeActions(
		@ViewBuilder actions: @escaping () -> some View
	) -> some View {
		self.modifier(CaseStudySwipeActionsModifier(actions: actions))
	}

	func caseStudySwipeActionsContainer() -> some View {
		self.modifier(CaseStudySwipeActionsContainerModifier())
	}
}
