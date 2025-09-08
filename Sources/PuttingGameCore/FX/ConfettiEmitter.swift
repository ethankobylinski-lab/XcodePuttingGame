#if canImport(SpriteKit)
@preconcurrency import SpriteKit
@preconcurrency import CoreGraphics

/// A reusable confetti effect backed by up to three `SKEmitterNode` instances.
@MainActor
public final class ConfettiEmitter: SKNode {
    private let tuning: FXTuning.Confetti
    private var emitters: [SKEmitterNode] = []

    /// Creates a new emitter using the global `FXTuning.confetti` values by default.
    public init(tuning: FXTuning.Confetti = FXTuning.confetti) {
        self.tuning = tuning
        super.init()
        setupEmitters()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    private func setupEmitters() {
        // Ensure we never allocate more than three emitter nodes.
        let count = min(tuning.nodeCount, 3)
        emitters = (0..<count).map { _ in
            let node = SKEmitterNode()
            node.particleTexture = SKTexture(imageNamed: "confetti")
            node.numParticlesToEmit = tuning.maxParticles
            node.particleBirthRate = tuning.birthRate
            node.particleLifetime = tuning.lifetime
            node.particleSpeed = tuning.speed
            node.particleScale = tuning.scale
            node.particlePositionRange = CGVector(dx: 200, dy: 0)
            addChild(node)
            return node
        }
    }

    /// Triggers the confetti burst at the supplied position.
    public func emit(at position: CGPoint) {
        self.position = position
        for emitter in emitters {
            emitter.resetSimulation()
            emitter.particleBirthRate = tuning.birthRate
        }
    }

    /// Stops all emission immediately.
    public func stop() {
        emitters.forEach { $0.particleBirthRate = 0 }
    }
}
#endif

