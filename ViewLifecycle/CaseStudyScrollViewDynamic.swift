import SwiftUI

struct CaseStudyScrollViewDynamic: View {
	private static let initialCount = 10

	@State private var items: [Item] = (1 ... Self.initialCount).map { i in Item(id: "Item \(i)") }

	@State private var nextID: Int = Self.initialCount + 1

	var body: some View {
		ScrollViewCaseStudy(
			caseStudy: .scrollViewDynamic,
			explanation: "Dynamic `ScrollView` content is still created with the scroll view. Prepending, appending, or deleting items changes which child views exist, and the event log stays visible while the content scrolls.",
			isEventLogClearable: true
		) { recordEntry in
			HStack {
				Spacer()

				Button {
					self.prependItem(recordEntry: recordEntry)
				} label: {
					Label("Prepend", systemImage: "text.insert")
						.labelStyle(.iconOnly)
				}
				.buttonStyle(.glass)

				Button {
					self.appendItem(recordEntry: recordEntry)
				} label: {
					Label("Append", systemImage: "text.append")
						.labelStyle(.iconOnly)
				}
				.buttonStyle(.glass)
			}

			ForEach(self.items) { item in
				HStack(alignment: .top, spacing: 12) {
					LifecycleMonitor(label: item.id, recordEntry: recordEntry)

					Button(role: .destructive) {
						self.delete(item, recordEntry: recordEntry)
					} label: {
						Label("Delete", systemImage: "minus.circle")
							.labelStyle(.iconOnly)
					}
					.buttonStyle(.glass)
					.tint(.red)
				}
			}
		}
		.animation(.default, value: self.items)
	}

	private func appendItem(recordEntry: (TimelineEntry) -> Void) -> Void {
		let newItem = self.nextItem()

		recordEntry(TimelineEntry(event: .action(.appended(newItem.id))))

		self.items.append(newItem)
	}

	private func prependItem(recordEntry: (TimelineEntry) -> Void) -> Void {
		let newItem = self.nextItem()

		recordEntry(TimelineEntry(event: .action(.prepended(newItem.id))))

		self.items.insert(newItem, at: 0)
	}

	private func delete(_ item: Item, recordEntry: (TimelineEntry) -> Void) -> Void {
		guard let index = self.items.firstIndex(where: { $0.id == item.id }) else { return }

		recordEntry(TimelineEntry(event: .action(.deleted(item.id))))

		self.items.remove(at: index)
	}

	private func nextItem() -> Item {
		defer { self.nextID += 1 }

		return Item(id: "Item \(self.nextID)")
	}
}

#Preview {
	NavigationStack {
		CaseStudyScrollViewDynamic()
	}
}
