import Plugin

/// A plugin that can be registered with a `TaskPluginManager`.
public protocol TaskPlugin: Plugin {
    /// Handles an input value.
    ///
    /// This method is called by the task manager when a plugin receives an input value. Plugins can use this method to modify the
    /// task output, perform cleanup operations, or add additional behavior to the task.
    ///
    /// - Parameters:
    ///   - value: The input value to handle.
    ///   - output: A reference to a task manager value.
    ///
    /// - Throws: An error if the plugin fails to handle the input value.
    func handle(
        value: Input,
        output: inout Output
    ) async throws
}

extension TaskPlugin where Source == TaskPluginManager<Any>, Output == Task<Any, Error>? {
    /// The key path used to access the task associated with the plugin manager.
    public var keyPath: WritableKeyPath<TaskPluginManager<Any>, Task<Any, Error>?> {
        get { \.task }
        set { }
    }
}
