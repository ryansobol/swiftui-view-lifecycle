import SwiftUI

struct CaseStudyListStatic: View {
	private static let itemCount = 10
	private static let items: [Item] = (1 ... Self.itemCount).map { i in
		Item(id: "Item \(i)")
	}

	var body: some View {
		ListCaseStudy(
			caseStudy: .listStatic,
			explanation: "Static `List` content is still lazily created and recycled as rows move on and off screen. Unlike static `ScrollView` content, the event log shows that off-screen list rows do not appear until the list scrolls them into view."
		) { recordEntry in
			ForEach(Self.items) { item in
				LifecycleMonitor(label: item.id, recordEntry: recordEntry)
			}
		}
	}
}

#Preview {
	CaseStudyListStatic()
}
