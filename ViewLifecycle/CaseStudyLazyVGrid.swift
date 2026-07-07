import SwiftUI

struct CaseStudyLazyVGrid: View {
	private static let itemCount = 20
	private static let columns = [
		GridItem(.adaptive(minimum: 180), spacing: 4),
	]

	@State private var items: [Item] = (1 ... Self.itemCount).map { i in Item(id: "Item \(i)") }

	@State private var nextID: Int = Self.itemCount + 1

	var body: some View {
		ScrollViewCaseStudy(
			caseStudy: .lazyVGrid,
			explanation: "`LazyVGrid` content is lazily created inside a `ScrollView`. Prepending, appending, or deleting items changes which child views exist, and the event log shows lifecycle events across adaptive grid cells."
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
			.padding(.horizontal)

			LazyVGrid(columns: Self.columns) {
				ForEach(self.items) { item in
					VStack(spacing: 4) {
						LifecycleMonitor(
							label: item.id,
							style: .compact,
							recordEntry: recordEntry
						)

						Button(role: .destructive) {
							self.delete(item, recordEntry: recordEntry)
						} label: {
							Label("Delete", systemImage: "minus.circle")
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
	CaseStudyLazyVGrid()
}
