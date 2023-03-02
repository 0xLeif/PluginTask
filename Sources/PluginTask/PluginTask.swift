import Plugin

/// Creates a task for executing async code with plugins.
///
/// - Parameters:
///   - priority: The priority of the task. Defaults to `nil`.
///   - manager: The plugin manager to use for the task. Defaults to a new `TaskPluginManager`.
///   - plugins: The plugins to register with the plugin manager. Defaults to an empty array.
///   - operation: The async operation to execute with the plugin manager.
/// - Returns: A task that executes the specified operation with the specified plugins.
public func PluginTask<Success>(
    priority: TaskPriority? = nil,
    manager: TaskPluginManager<Success> = TaskPluginManager(),
    plugins: [any Plugin] = [],
    operation: @escaping (TaskPluginManager<Success>) async throws -> Success
) -> Task<Success, Error> {
    let taskManager = manager
    taskManager.register(plugins: plugins)
    
    let task: Task<Success, Error> = Task(priority: priority) {
        try await operation(taskManager)
    }
    
    taskManager.task = task
    return task
}

/// Creates a task for executing async code with plugins.
///
/// - Parameters:
///   - priority: The priority of the task. Defaults to `nil`.
///   - manager: The plugin manager to use for the task. Defaults to a new `TaskPluginManager`.
///   - plugins: The plugins to register with the plugin manager. Defaults to an empty array.
///   - operation: The async operation to execute with the plugin manager.
/// - Returns: A task that executes the specified operation with the specified plugins.
public func PluginTask(
    priority: TaskPriority? = nil,
    manager: TaskPluginManager<Void> = TaskPluginManager(),
    plugins: [any Plugin] = [],
    operation: @escaping (TaskPluginManager<Void>) async throws -> Void
) -> Task<Void, Error> {
    let taskManager = manager
    taskManager.register(plugins: plugins)

    let task: Task<Void, Error> = Task(priority: priority) {
        try await operation(taskManager)
    }

    taskManager.task = task
    return task
}
