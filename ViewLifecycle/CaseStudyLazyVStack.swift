import SwiftUI

struct CaseStudyLazyVStack: View {
	private static let itemCount = 10

	let recordEntry: (TimelineEntry) -> Void

	@State private var items: [Item] = (1 ... Self.itemCount).map { i in Item(id: "Item \(i)") }

	@State private var nextID: Int = Self.itemCount + 1

	var body: some View {
		ScrollViewCaseStudy(
			explanation: "`LazyVStack` creates children as they approach the viewport instead of building the whole stack up front. A child's lifetime starts when scrolling brings it near, not when its data enters the stack.",
			usesSwipeActionsContainer: true
		) {
			CaseStudyItemActions(
				prepend: {
					self.prependItem(recordEntry: self.recordEntry)
				},
				append: {
					self.appendItem(recordEntry: self.recordEntry)
				}
			)

			LazyVStack(spacing: 16) {
				ForEach(self.items) { item in
					LifecycleMonitor(title: item.id, recordEntry: self.recordEntry)
						.caseStudySwipeActions {
							CaseStudySwipeActionButton {
								self.delete(item, recordEntry: self.recordEntry)
							} label: {
								Label("Delete", systemImage: "trash")
							}
						}
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
		CaseStudyLazyVStack { entry in
			recordEntry(.lazyVStack, entry)
		}
	}
}
