import Foundation
import Swinject

public extension Container {
    /// Registers a service whose initializer is `@MainActor`-isolated.
    ///
    /// Swinject factories are nonisolated. `MainActor.assumeIsolated` bridges that only for
    /// `Sendable` results: `@MainActor` classes are, non-isolated values such as `ModelContext`
    /// are not — hence the unsafe erasure below.
    ///
    /// - Precondition: resolved from the main thread.
    @discardableResult
    func autoregisterOnMain<S, each A>(
        _ initializer: @escaping @MainActor (repeat each A) -> S
    ) -> ServiceEntry<S> {
        register(S.self) { resolver in
            // The resolver is not Sendable and the closure below is @MainActor, so the
            // capture would otherwise read as sending a value across an isolation boundary.
            nonisolated(unsafe) let resolver = resolver

            return assumingMainActor {
                initializer(repeat resolved((each A).self, from: resolver))
            }
        }
    }

    /// Registers a service built by a `@MainActor`-isolated factory — for values that are
    /// reached rather than constructed, such as `ModelContainer.mainContext`.
    ///
    /// - Precondition: resolved from the main thread.
    @discardableResult
    func registerOnMain<S>(
        _ type: S.Type,
        factory: @escaping @MainActor (Resolver) -> S
    ) -> ServiceEntry<S> {
        register(type) { resolver in
            nonisolated(unsafe) let resolver = resolver

            return assumingMainActor {
                factory(resolver)
            }
        }
    }
}

// `MainActor.assumeIsolated` without its `T: Sendable` requirement — same bit cast as in stdlib.
private func assumingMainActor<T>(_ body: @MainActor () -> T) -> T {
    precondition(
        Thread.isMainThread,
        "A @MainActor service was resolved off the main thread — resolve it from the main thread instead."
    )

    return withoutActuallyEscaping(body) { body in
        unsafeBitCast(body, to: (() -> T).self)()
    }
}
