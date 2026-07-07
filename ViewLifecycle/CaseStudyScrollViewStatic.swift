import SwiftUI

struct CaseStudyScrollViewStatic: View {
	private static let itemCount = 10
	private static let items: [Item] = (1 ... Self.itemCount).map { i in
		Item(id: "Item \(i)")
	}

	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		ScrollViewCaseStudy(
			explanation: "Static `ScrollView` content is created with the scroll view, even when some items start off screen. Unlike static `List` content, the event log shows that all eight items appear without scrolling them into view."
		) {
			ForEach(Self.items) { item in
				LifecycleMonitor(label: item.id, recordEntry: self.recordEntry)
			}
		}
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyScrollViewStatic { entry in
			recordEntry(.scrollViewStatic, entry)
		}
	}
}
