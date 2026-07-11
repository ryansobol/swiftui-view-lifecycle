import SwiftUI

struct CaseStudyList: View {
	private static let itemCount = 10

	let recordEntry: (TimelineEntry) -> Void

	@State private var items: [Item] = (1 ... Self.itemCount).map { i in Item(id: "Item \(i)") }

	@State private var nextID: Int = Self.itemCount + 1

	var body: some View {
		ListCaseStudy(
			explanation: "`List` lazily creates and recycles rows as they move through the viewport. Row events may not follow data order, and a row can be recreated while its data is still in the collection."
		) {
			CaseStudyItemActions(
				prepend: {
					self.prependItem(recordEntry: self.recordEntry)
				},
				append: {
					self.appendItem(recordEntry: self.recordEntry)
				}
			)

			ForEach(self.items) { item in
				LifecycleMonitor(title: item.id, recordEntry: self.recordEntry)
			}
			.onDelete { offsets in
				self.deleteItems(at: offsets, recordEntry: self.recordEntry)
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
	LifecycleSession { recordEntry in
		NavigationStack {
			CaseStudyList { entry in
				recordEntry(.list, entry)
			}
		}
	}
}
