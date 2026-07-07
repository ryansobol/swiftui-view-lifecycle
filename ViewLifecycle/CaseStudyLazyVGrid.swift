import OSLog
import SwiftUI

struct CaseStudyLazyVGrid: View {
	private static let itemCount = 16
	private static let columns = [
		GridItem(.adaptive(minimum: 180), spacing: 0),
	]

	@State private var items: [Item] = (1 ... Self.itemCount).map { i in Item(id: "Item \(i)") }

	@State private var nextID: Int = Self.itemCount + 1
	@State private var entries = [TimelineEntry]()

	var body: some View {
		ScrollView {
			VStack(spacing: 16) {
				Group {
					CaseStudyExplanation(
						text: "`LazyVGrid` content is lazily created inside a `ScrollView`. Prepending, appending, or deleting items changes which child views exist, and the event log shows lifecycle events across adaptive grid cells."
					)

					HStack {
						Spacer()

						Button {
							self.prependItem()
						} label: {
							Label("Prepend", systemImage: "text.insert")
								.labelStyle(.iconOnly)
						}
						.buttonStyle(.glass)

						Button {
							self.appendItem()
						} label: {
							Label("Append", systemImage: "text.append")
								.labelStyle(.iconOnly)
						}
						.buttonStyle(.glass)
					}
				}
				.padding(.horizontal)

				LazyVGrid(columns: Self.columns) {
					ForEach(self.items) { item in
						VStack(spacing: 4) {
							LifecycleMonitor(label: item.id, recordEntry: self.recordEntry)

							Button(role: .destructive) {
								self.delete(item)
							} label: {
								Label("Delete", systemImage: "minus.circle")
							}
							.buttonStyle(.glass)
							.tint(.red)
						}
						.padding(4)
					}
				}
			}
			.padding(.vertical)
		}
		.safeAreaInset(edge: .bottom) {
			EventLog(entries: self.$entries)
				.frame(height: 220)
				.padding()
				.background(.regularMaterial)
		}
		.animation(.default, value: self.items)
	}

	private var logger: Logger {
		return .caseStudy(.lazyVGrid)
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
	CaseStudyLazyVGrid()
}
