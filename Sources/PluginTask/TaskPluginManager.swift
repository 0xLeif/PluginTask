import Plugin

/// A manager for Task plugins.
open class TaskPluginManager<Success>: Pluginable {
    /// The plugins registered with the manager.
    open var plugins: [any Plugin]

    /// The task associated with the manager.
    open var task: Task<Success, Error>?

    /// Initializes a new task plugin manager.
    ///
    /// - Parameter plugins: The plugins to register with the manager. Defaults to an empty array.
    public init(plugins: [any Plugin] = []) {
        self.plugins = plugins
    }

    /// Cancels the task associated with the manager, but only if a `CancelTaskPlugin` is registered with the manager.
    ///
    /// This method sends a `CancelTaskPlugin.Payload.cancel` value to all registered plugins.
    ///
    /// - Throws: An error if any plugin throws an error while handling the cancel signal.
    open func cancel() async throws {
        try await handle(value: CancelTaskPlugin.Payload.cancel)
    }
}
