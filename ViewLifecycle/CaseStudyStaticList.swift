import SwiftUI

struct CaseStudyStaticList: View {
	private static let itemCount = 10
	private static let items: [Item] = (1 ... Self.itemCount).map { i in
		Item(id: "Item \(i)")
	}

	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		ListCaseStudy(
			explanation: "A static `List` renders an immutable collection of rows. `List` creates row views lazily as scrolling brings them into range, and rows may disappear, reappear with existing state, or be recreated after the list releases them."
		) {
			ForEach(Self.items) { item in
				LifecycleMonitor(label: item.id, recordEntry: self.recordEntry)
			}
		}
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyStaticList { entry in
			recordEntry(.staticList, entry)
		}
	}
}
