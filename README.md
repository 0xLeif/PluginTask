# PluginTask

*🧩 A Task that supports plugins*

`PluginTask` is a custom `Task` that allows users to add plugins to modify its behavior. Plugins can be added to the `PluginTask` instance to perform additional functionality before or after the task's main operation. This makes it easy to modify the task's behavior without modifying its original implementation.

## Usage

### Creating a TaskPluginManager

The `TaskPluginManager` is responsible for managing the plugins that are registered with it. You can create a new `TaskPluginManager` instance by initializing it with an array of `Plugin` instances.

```swift
class ImageTaskPluginManager: TaskPluginManager {
    var image: Image?
}
```

### Creating a TaskPlugin

Before creating a `PluginTask`, you need to create a `TaskPlugin` to implement the additional functionality that you want to add. A `TaskPlugin` is a Swift struct or class that conforms to the `Plugin` protocol and implements the required handle method.


```swift
struct ImageDownloadingPlugin: TaskPlugin {
    var keyPath: WritableKeyPath<ImageTaskPluginManager, Image?> = \.image

    func handle(value: URL, output: inout Image?) async throws {
        let data: Data = try await fetchImage(url: value)
        let image: UIImage = UIImage(data: data)!
        output = Image(uiImage: image)
    }
}
```

In this example, we define a custom TaskPluginManager that includes a property to hold the downloaded image. We then define a TaskPlugin that downloads an image from a given URL and stores it in the TaskPluginManager.



### Creating a PluginTask

To create a `PluginTask`, you need to initialize it with a `TaskPluginManager`. The `TaskPluginManager` is responsible for managing the plugins and invoking them at the appropriate times during the task's execution.

```swift
let taskPluginManager = ImageTaskPluginManager()
let pluginTask: Task<Void, Error> = PluginTask(manager: taskPluginManager) { manager in
    let url = URL(string: "https://example.com/image.jpg")!
    try await manager.handle(value: url)
}
```

In this example, we create a new `ImageTaskPluginManager` instance and use it to initialize a new `PluginTask`. We then define the main operation of the task, which downloads an image from a URL and stores it in the `TaskPluginManager` using the `handle` method.
