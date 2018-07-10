import Foundation
import Yosemite
import Storage
import Networking



// MARK: - AuthenticatedState
//
class AuthenticatedState: StoresManagerState {

    /// Dispatcher: Glues all of the Stores!
    ///
    private let dispatcher = Dispatcher()

    /// Retains all of the active Services
    ///
    private let services: [ActionsProcessor]


    /// Designated Initializer
    ///
    init(credentials: Credentials) {
        let storageManager = CoreDataManager.global
        let network = AlamofireNetwork(credentials: credentials)

        services = [
            AccountStore(dispatcher: dispatcher, storageManager: storageManager, network: network),
            OrderStore(dispatcher: dispatcher, storageManager: storageManager, network: network),
            OrderNoteStore(dispatcher: dispatcher, storageManager: storageManager, network: network)
        ]
    }

    /// Convenience Initializer
    ///
    convenience init?(sessionManager: SessionManager) {
        guard let credentials = sessionManager.defaultCredentials else {
            return nil
        }

        self.init(credentials: credentials)
    }


    /// Executed whenever the state is activated.
    ///
    func didEnter() { }


    /// Forwards the received action to the Actions Dispatcher.
    ///
    func onAction(_ action: Action) {
        dispatcher.dispatch(action)
    }
}
