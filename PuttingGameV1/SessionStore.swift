import Foundation
import PuttingGameCore

@MainActor
final class SessionStore: ObservableObject {
    @Published var activeSession: Session? {
        didSet { save() }
    }

    private let url: URL

    init(fileManager: FileManager = .default) {
        url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("activeSession.json")
        load()
    }

    func save() {
        guard let session = activeSession else {
            try? FileManager.default.removeItem(at: url)
            return
        }
        do {
            let data = try JSONEncoder().encode(session)
            try data.write(to: url, options: .atomic)
        } catch {
            print("Failed to save session: \(error)")
        }
    }

    func load() {
        guard let data = try? Data(contentsOf: url),
              let session = try? JSONDecoder().decode(Session.self, from: data),
              session.end > .now else {
            activeSession = nil
            return
        }
        activeSession = session
    }
}
