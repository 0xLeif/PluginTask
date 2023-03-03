import t
import XCTest
@testable import PluginTask

final class PluginTaskTests: XCTestCase {
    func testPluginTask() async throws {
        let operation: Task<Sendable, Error> = PluginTask(
            operation: { manager in
                // Don't not cancels the task associated with the manager.
                // Because a `CancelTaskPlugin` is not registered with the manager.
                try await manager.cancel()

                return Double.pi
            }
        )

        try await t.expect {
            let output = try await operation.value(as: Double.self)

            try t.assert(output, isEqualTo: Double.pi)
        }
    }

    func testCancelPluginTask() async throws {
        let operation: Task<Sendable, Error> = PluginTask(
            manager: TaskPluginManager<Sendable>(
                plugins: [
                    CancelTaskPlugin()
                ]
            ),
            operation: { manager in
                // Will cancel the task associated with the manager
                // Because a `CancelTaskPlugin` is registered with the manager.
                try await manager.cancel()

                return Double.pi
            }
        )

        try await t.expect {
            try await t.assertThrows {
                _ = try await operation.value(as: Double.self)
            }
        }
    }

    func testVoidPluginTask() async throws {
        var count = 0

        let operation: Task<Void, Error> = PluginTask { manager in
            count += 1
        }

        try await t.expect {
            try await operation.value

            try t.assert(count, isEqualTo: 1)
        }
    }
}
