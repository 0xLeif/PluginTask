import Plugin

/// A plugin that cancels the task when a `cancel` payload is received.
public struct CancelTaskPlugin: TaskPlugin {
    /// The payload type for the plugin.
    public enum Payload {
        /// A payload that signals the task should be canceled.
        case cancel
    }

    /// Initializes a new cancel task plugin.
    public init() { }

    /// Handles a payload value.
    ///
    /// If the payload is `.cancel`, this method cancels the task associated with the `output` parameter.
    ///
    /// - Parameters:
    ///   - value: The input value to handle.
    ///   - output: A reference to the task associated with the plugin.
    ///
    /// - Throws: An error if the plugin fails to handle the input value.
    public func handle(
        value: Payload,
        output: inout Task<Any, Error>?
    ) async throws {
        output?.cancel()
    }
}
