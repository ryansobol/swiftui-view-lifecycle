import SwiftUI

struct CaseStudyListDynamic: View {
	private static let itemCount = 8

	@State private var items: [Item] = (1 ... Self.itemCount).map { i in Item(id: "Item \(i)") }

	@State private var nextID: Int = Self.itemCount + 1

	var body: some View {
		ListCaseStudy(
			caseStudy: .listDynamic,
			explanation: "Dynamic `List` content is lazily created and recycled as rows move on and off screen. Prepending, appending, or deleting items changes which rows exist, and the event log shows both row lifecycle events and list mutations."
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
				LifecycleMonitor(label: item.id, recordEntry: recordEntry)
			}
			.onDelete { offsets in
				self.deleteItems(at: offsets, recordEntry: recordEntry)
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

	private func deleteItems(
		at offsets: IndexSet,
		recordEntry: (TimelineEntry) -> Void
	) -> Void {
		for item in offsets.map({ self.items[$0] }) {
			recordEntry(TimelineEntry(event: .action(.deleted(item.id))))
		}

		self.items.remove(atOffsets: offsets)
	}

	private func nextItem() -> Item {
		defer { self.nextID += 1 }

		return Item(id: "Item \(self.nextID)")
	}
}

#Preview {
	NavigationStack {
		CaseStudyListDynamic()
	}
}
