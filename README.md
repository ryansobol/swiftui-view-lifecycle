# SwiftUI View Lifecycle

An iOS and macOS app that demonstrates how different SwiftUI constructs and SwiftUI container views affect:

- the lifetime of `@State`
- the firing of lifecycle events such as `task`, `onAppear`, and `onDisappear`

Originally by [Ole Begemann](https://oleb.net), 2022. This fork is maintained by Ryan Sobol.

[Original SwiftUI View Lifecycle app on GitHub](https://github.com/ole/swiftui-view-lifecycle)<br>
Ole's article introducing the original app: [Understanding View Lifecycles (2022-12-15)](https://oleb.net/2022/swiftui-view-lifecycle/)

## Usage

1. Open the project in Xcode.
2. Run the app on the iOS simulator, an iOS device, or on macOS.
3. Tap or click through the list of examples and observe the timestamps when certain lifecycle events happen.

## Requirements

Requires iOS 26.0 or macOS 26.0.

## Screenshots

### iPhone

<img src="assets/ios-collage.png" width="692" height="339"/>

### iPad

<img src="assets/ipad-tabview.png" width="658" height="477"/>

### Mac

<img src="assets/mac-list-dynamic.png" width="749" height="525"/>

## The `LifecycleMonitor` view

All examples use one or more [`LifecycleMonitor`](ViewLifecycle/LifecycleMonitor.swift) views as their content. The view below tracks its lifecycle events and displays them as constantly-updating timestamps. For example, this view got created 1:26 minutes ago, which is also when its `@State` got created. Its `.task`, `.onAppear`, and `.onDisappear` actions show when SwiftUI last ran each modifier for the view:

<img src="assets/LifecycleMonitor-example.png" width="331" height="123"/>

As you interact with the app, e.g. by scrolling through a `List`, you’ll see these timestamps update (or not, depending on the container view). Pay special attention to resets of the `@State` field because this means that the view got destroyed and recreated, losing all of its internal state.

The view’s background color is chosen from a rotating palette when its `@State` is created, so color changes are another indication that the view identity has changed.

## License

[MIT license](LICENSE.md)
