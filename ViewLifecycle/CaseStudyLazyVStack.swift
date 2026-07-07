import OSLog
import SwiftUI

struct CaseStudyLazyVStack: View {
	private static let itemCount = 10

	@State private var items: [Item] = (1 ... Self.itemCount).map { i in Item(id: "Item \(i)") }

	@State private var nextID: Int = Self.itemCount + 1
	@State private var entries = [TimelineEntry]()

	var body: some View {
		ScrollView {
			VStack(spacing: 16) {
				Group {
					CaseStudyExplanation(
						text: "`LazyVStack` content is lazily created inside a `ScrollView`. Prepending, appending, or deleting items changes which child views exist, and the event log shows lifecycle events without `List` row recycling."
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

				LazyVStack(spacing: 16) {
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
						}
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
		return .caseStudy(.lazyVStack)
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
	CaseStudyLazyVStack()
}
