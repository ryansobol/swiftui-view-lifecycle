import SwiftUI

struct CaseStudyStaticVStack: View {
	private static let itemCount = 10
	private static let items: [Item] = (1 ... Self.itemCount).map { i in
		Item(id: "Item \(i)")
	}

	let recordEntry: (TimelineEntry) -> Void

	var body: some View {
		ScrollViewCaseStudy(
			explanation: "A static `VStack` inside a `ScrollView` renders an immutable collection of items. `VStack` creates every child eagerly, so each item starts its lifetime as soon as the scroll view appears, even if it begins off screen."
		) {
			ForEach(Self.items) { item in
				LifecycleMonitor(label: item.id, recordEntry: self.recordEntry)
			}
		}
	}
}

#Preview {
	LifecycleSession { recordEntry in
		CaseStudyStaticVStack { entry in
			recordEntry(.staticVStack, entry)
		}
	}
}
