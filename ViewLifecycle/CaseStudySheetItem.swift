import SwiftUI

struct CaseStudySheetItem: View {
	let recordEntry: (TimelineEntry) -> Void

	@State private var presentedSheet: PresentedSheet? = nil

	var body: some View {
		TimelineCaseStudy(
			explanation: "`sheet(item:)` keeps the presenter alive while item identity controls the sheet content. Replacing the item removes the sheet before the next sheet creates content. Dismissing then presenting the same sheet again recreates fresh content."
		) {
			LifecycleMonitor(label: "Presenter", recordEntry: self.recordEntry)

			VStack(spacing: 12) {
				ForEach(PresentedSheet.allCases) { sheet in
					Button {
						self.present(sheet)
					} label: {
						Label(sheet.presentationButtonLabel, systemImage: sheet.systemImage)
					}
					.buttonStyle(.glassProminent)
				}
			}
			.frame(maxWidth: .infinity, alignment: .center)
		}
		.sheet(item: self.$presentedSheet) { sheet in
			SheetContent(
				sheet: sheet,
				recordEntry: self.recordEntry,
				present: self.present
			)
		}
	}

	private func present(_ sheet: PresentedSheet) -> Void {
		self.recordEntry(TimelineEntry(event: .action(.selected(sheet.monitorLabel))))

		self.presentedSheet = sheet
	}
}

private enum PresentedSheet: String, CaseIterable, Identifiable {
	case first
	case second

	var id: Self {
		self
	}

	var presentationButtonLabel: String {
		return switch self {
		case .first: "Present 1st sheet"
		case .second: "Present 2nd sheet"
		}
	}

	var replacementButtonLabel: String {
		return switch self {
		case .first: "Replace with 1st sheet"
		case .second: "Replace with 2nd sheet"
		}
	}

	var monitorLabel: String {
		return switch self {
		case .first: "1st sheet"
		case .second: "2nd sheet"
		}
	}

	var systemImage: String {
		return switch self {
		case .first: "1.circle"
		case .second: "2.circle"
		}
	}

	var alternate: Self {
		return switch self {
		case .first: .second
		case .second: .first
		}
	}
}

private struct SheetContent: View {
	@Environment(\.dismiss) private var dismiss

	let sheet: PresentedSheet
	let recordEntry: (TimelineEntry) -> Void
	let present: (PresentedSheet) -> Void

	var body: some View {
		VStack(spacing: 16) {
			LifecycleMonitor(label: self.sheet.monitorLabel, recordEntry: self.recordEntry)

			CaseStudyExplanation(
				text: "This content belongs to `\(self.sheet.monitorLabel)`. Replacing the item removes this sheet before the next sheet creates content. Dismissing and presenting the same sheet again recreates fresh content."
			)

			VStack(spacing: 12) {
				Button {
					self.present(self.sheet.alternate)
				} label: {
					Label(
						self.sheet.alternate.replacementButtonLabel,
						systemImage: self.sheet.alternate.systemImage
					)
				}
				.buttonStyle(.glassProminent)

				Button(role: .destructive) {
					self.recordEntry(
						TimelineEntry(event: .action(.tapped("Dismiss \(self.sheet.monitorLabel)")))
					)

					self.dismiss()
				} label: {
					Label {
						Text("Dismiss")
							.foregroundStyle(.primary)
					} icon: {
						Image(systemName: "xmark.circle")
					}
				}
				.buttonStyle(.glassProminent)
				.tint(.red)
			}
			.frame(maxWidth: .infinity)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.padding()
		.presentationDetents([.medium, .large])
		.presentationDragIndicator(.visible)
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudySheetItem { entry in
			recordEntry(.sheetItem, entry)
		}
	}
}
