import Foundation

extension Task {
    /// An error thrown when the task output is of an unexpected type.
    public struct InvalidTypeError<ExpectedType>: LocalizedError {
        /// The expected output type.
        public let expectedType: ExpectedType.Type

        /// The actual output value.
        public let actualValue: Any?

        /// Initializes a new instance of the error.
        ///
        /// - Parameters:
        ///   - expectedType: The expected output type.
        ///   - actualValue: The actual output value.
        public init(
            expectedType: ExpectedType.Type,
            actualValue: Any?
        ) {
            self.expectedType = expectedType
            self.actualValue = actualValue
        }

        /// A localized description of the error.
        public var errorDescription: String? {
            "Invalid Type: (Expected: \(expectedType.self)) got \(type(of: actualValue))"
        }
    }

    /// Returns the task output as a value of the specified type.
    ///
    /// This method is a convenience method for safely accessing the output of a task. It checks whether the output is of the expected
    /// type, and throws an error if it is not.
    ///
    /// - Parameters:
    ///   - type: The expected output type.
    ///
    /// - Returns: The output value of the task.
    ///
    /// - Throws: An error if the task output is of an unexpected type.
    public func value<Value: Sendable>(as type: Value.Type = Value.self) async throws -> Value {
        let output = try await value

        guard let value = output as? Value else {
            throw InvalidTypeError(expectedType: Value.self, actualValue: output)
        }

        return value
    }
}
