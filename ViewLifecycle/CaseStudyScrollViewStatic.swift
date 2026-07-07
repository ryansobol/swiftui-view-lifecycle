import SwiftUI

struct CaseStudyScrollViewStatic: View {
	private static let itemCount = 8
	private static let items: [Item] = (1 ... Self.itemCount).map { i in
		Item(id: "Item \(i)")
	}

	var body: some View {
		ScrollViewCaseStudy(
			caseStudy: .scrollViewStatic,
			explanation: "Static `ScrollView` content is created with the scroll view, even when some items start off screen. Unlike static `List` content, the event log shows that all eight items appear without scrolling them into view.",
			isEventLogClearable: false
		) { recordEntry in
			ForEach(Self.items) { item in
				LifecycleMonitor(label: item.id, recordEntry: recordEntry)
			}
		}
	}
}

#Preview {
	CaseStudyScrollViewStatic()
}
