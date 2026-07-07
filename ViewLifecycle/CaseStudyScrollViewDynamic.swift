import OSLog
import SwiftUI

struct CaseStudyScrollViewDynamic: View {
	private static let initialItemCount = 8

	@State private var items: [Item] = (1 ... Self.initialItemCount).map { i in
		Item(id: "Item \(i)")
	}

	@State private var nextID: Int = Self.initialItemCount + 1
	@State private var entries = [TimelineEntry]()

	var body: some View {
		ScrollViewCaseStudy(
			explanation: "Dynamic `ScrollView` content is still created with the scroll view. Prepending, appending, or deleting items changes which child views exist, and the event log stays visible while the content scrolls.",
			entries: self.$entries,
			isEventLogClearable: true
		) {
			ForEach(self.items) { item in
				HStack(alignment: .top, spacing: 12) {
					LifecycleMonitor(label: item.id, recordEntry: self.recordEntry)

					Button(role: .destructive) {
						self.delete(item)
					} label: {
						Label("Delete", systemImage: "minus.circle")
							.labelStyle(.iconOnly)
					}
					.buttonStyle(.glass)
					.tint(.red)
					.controlSize(.small)
				}
			}
		}
		.toolbar {
			ToolbarItem {
				Button(action: self.prependItem) {
					Label("Prepend", systemImage: "text.insert")
				}
			}
			ToolbarItem {
				Button(action: self.appendItem) {
					Label("Append", systemImage: "text.append")
				}
			}
		}
		.animation(.default, value: self.items)
	}

	private var logger: Logger {
		return .caseStudy(.scrollViewDynamic)
	}

	private func appendItem() -> Void {
		let newItem = self.nextItem()

		self.recordEntry(TimelineEntry(event: .action(.appended(newItem.id))))

		self.items.append(newItem)
	}

	private func prependItem() -> Void {
		let newItem = self.nextItem()

		self.recordEntry(TimelineEntry(event: .action(.prepended(newItem.id))))

		self.items.insert(newItem, at: 0)
	}

	private func delete(_ item: Item) -> Void {
		guard let index = self.items.firstIndex(where: { $0.id == item.id }) else { return }

		self.recordEntry(TimelineEntry(event: .action(.deleted(item.id))))

		self.items.remove(at: index)
	}

	private func nextItem() -> Item {
		defer { self.nextID += 1 }

		return Item(id: "Item \(self.nextID)")
	}

	private func recordEntry(_ entry: TimelineEntry) -> Void {
		#if DEBUG
			print("\(entry.timestamp) \(entry.event.label)")
		#else
			self.logger.info("\(entry.event.label, privacy: .public)")
		#endif

		self.entries.append(entry)
	}
}

#Preview {
	NavigationStack {
		CaseStudyScrollViewDynamic()
	}
}
