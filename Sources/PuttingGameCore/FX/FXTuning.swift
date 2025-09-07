#if canImport(CoreGraphics)
import CoreGraphics

/// Central tuning table for in-game visual effects.
public enum FXTuning {
    /// Tunable parameters for the confetti emitter.
    public struct Confetti {
        /// Desired number of emitter nodes. The implementation caps this at three.
        public var nodeCount: Int
        /// Maximum number of particles emitted per node.
        public var maxParticles: Int
        /// Birth rate in particles per second.
        public var birthRate: CGFloat
        /// Lifetime of each particle in seconds.
        public var lifetime: CGFloat
        /// Initial speed of emitted particles.
        public var speed: CGFloat
        /// Scale applied to particle textures.
        public var scale: CGFloat

        public static let `default` = Confetti(
            nodeCount: 1,
            maxParticles: 100,
            birthRate: 40,
            lifetime: 3,
            speed: 200,
            scale: 0.5
        )
    }

    /// Current tuning values for the confetti effect.
    public static var confetti = Confetti.default
  }
#endif

