import SwiftUI

struct CaseStudyDynamicList: View {
	private static let itemCount = 10

	let recordEntry: (TimelineEntry) -> Void

	@State private var items: [Item] = (1 ... Self.itemCount).map { i in Item(id: "Item \(i)") }

	@State private var nextID: Int = Self.itemCount + 1

	var body: some View {
		ListCaseStudy(
			explanation: "A dynamic `List` renders a mutable collection of rows. `List` creates row views lazily as scrolling brings them into range, so visible insertions start immediately, offscreen insertions wait, and deleted rows end when removed."
		) {
			HStack {
				Spacer()

				Button {
					self.prependItem(recordEntry: self.recordEntry)
				} label: {
					Label("Prepend", systemImage: "text.insert")
						.labelStyle(.iconOnly)
				}
				.buttonStyle(.glass)

				Button {
					self.appendItem(recordEntry: self.recordEntry)
				} label: {
					Label("Append", systemImage: "text.append")
						.labelStyle(.iconOnly)
				}
				.buttonStyle(.glass)
			}

			ForEach(self.items) { item in
				LifecycleMonitor(label: item.id, recordEntry: self.recordEntry)
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
			CaseStudyDynamicList { entry in
				recordEntry(.dynamicList, entry)
			}
		}
	}
}
