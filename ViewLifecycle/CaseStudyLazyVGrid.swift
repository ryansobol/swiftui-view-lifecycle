import SwiftUI

struct CaseStudyLazyVGrid: View {
	private static let itemCount = 20
	private static let columns = [
		GridItem(.adaptive(minimum: 180), spacing: 4),
	]

	let recordEntry: (TimelineEntry) -> Void

	@State private var items: [Item] = (1 ... Self.itemCount).map { i in Item(id: "Item \(i)") }

	@State private var nextID: Int = Self.itemCount + 1

	var body: some View {
		ScrollViewCaseStudy(
			explanation: "`LazyVGrid` creates cells lazily in row-sized batches as grid rows approach the viewport. Cell lifetimes follow the grid's layout batches, not just each item's position in the data."
		) {
			CaseStudyItemActions(
				prepend: {
					self.prependItem(recordEntry: self.recordEntry)
				},
				append: {
					self.appendItem(recordEntry: self.recordEntry)
				}
			)

			LazyVGrid(columns: Self.columns) {
				ForEach(self.items) { item in
					VStack(spacing: 4) {
						LifecycleMonitor(
							label: item.id,
							style: .compact,
							recordEntry: self.recordEntry
						)

						Button(role: .destructive) {
							self.delete(item, recordEntry: self.recordEntry)
						} label: {
							Label {
								Text("Delete")
									.foregroundStyle(.primary)
							} icon: {
								Image(systemName: "trash")
							}
						}
						.padding(4)
						.buttonStyle(.glass)
						.tint(.red)
					}
					.padding(4)
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
	LifecycleSession { recordEntry in
		CaseStudyLazyVGrid { entry in
			recordEntry(.lazyVGrid, entry)
		}
	}
}
