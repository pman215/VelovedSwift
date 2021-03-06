//
//  MultiplayerGameStatus.swift
//  VelovedGame
//
//  Created by enadrade21 on 5/25/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//
import Foundation

class MultiplayerGameStatus: NSObject {

    weak var controller: MultiplayerGameController?

    init(controller: MultiplayerGameController) {
        self.controller = controller
        super.init()

        var message = controller.dequeueMessage()
        while message != nil {
            processMessage(message!)
            message = controller.dequeueMessage()
        }
    }

    func processMessage(message: MPCMessage) {
        let messageHandler = MPCMessage.getMessageHandler(message)
        messageHandler(self)
    }

    func forwardMessageToController(message: MPCMessage) {
        if let _ = controller {
//            println("\(self) forwarding \(message)\n")
            let messageHandler = MPCMessage.getMessageHandler(message)
            messageHandler(controller!)
        }
    }

    func queueMessageForProcessingLater(message: MPCMessage) {
//        println("\(self) queueing message \(message)")
        controller?.queueMessage(message)
    }

    func discardMessage(message: MPCMessage) {

        var errorMsg = "\(NSStringFromClass(self.dynamicType)) - \(__FUNCTION__): Discarded the following message \(message.description)"
        assertionFailure(errorMsg)
    }
}

extension MultiplayerGameStatus: GameMessages {

    func testMessage(message: MPCMessage) {
        assertionFailure("")
    }

    func initPlayer(message: MPCMessage) {
        assertionFailure("")
    }

    func didShowGameViewController(message: MPCMessage) {
        assertionFailure("")
    }

    func scheduleGame(message: MPCMessage) {
        assertionFailure("")
    }

    func didScheduleGame(message: MPCMessage) {
        assertionFailure("")
    }

    func elementDidMoveMessage(message: MPCMessage) {
        assertionFailure("")
    }

    func playerDidCrash(message: MPCMessage) {
        assertionFailure("")
    }

    func playerDidChangeDirection(message: MPCMessage) {
        assertionFailure("")
    }

    func playerDidSecureTarget(message: MPCMessage) {
        assertionFailure("")
    }

    func initTarget(message: MPCMessage) {
        assertionFailure("")
    }

    func targetWasSecured(message: MPCMessage) {
        assertionFailure("")
    }

    func targetDidUpdateLocation(message: MPCMessage) {
        assertionFailure("")
    }

    func pauseOrResumeGame(message: MPCMessage) {
        assertionFailure("")
    }

    func gameDidEnd(message: MPCMessage) {
        assertionFailure("")
    }

    func peerIsConnecting(#message: MPCMessage) {
        assertionFailure("")
    }

    func peerDidConnect(#message: MPCMessage) {
        assertionFailure("")
    }

    func peerDidNotConnect(#message: MPCMessage) {
        assertionFailure("")
    }
}


class MultiplayerGameIdleStatus: MultiplayerGameStatus, GameMessages {
    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func initPlayer(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func scheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidChangeDirection(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidSecureTarget(message: MPCMessage) {
        discardMessage(message)
    }

    override func initTarget(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func targetWasSecured(message: MPCMessage) {
        discardMessage(message)
    }

    override func targetDidUpdateLocation(message: MPCMessage) {
        discardMessage(message)
    }

    override func pauseOrResumeGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        discardMessage(message)
    }

    override func peerIsConnecting(#message: MPCMessage) {
        discardMessage(message)
    }

    override func peerDidConnect(#message: MPCMessage) {
        discardMessage(message)
    }

    override func peerDidNotConnect(#message: MPCMessage) {
        forwardMessageToController(message)
    }
}

class MultiplayerGameModelInitStatus: MultiplayerGameStatus, GameMessages {

    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func initPlayer(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func scheduleGame(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidChangeDirection(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidSecureTarget(message: MPCMessage) {
        discardMessage(message)
    }

    override func initTarget(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func targetWasSecured(message: MPCMessage) {
        discardMessage(message)
    }

    override func targetDidUpdateLocation(message: MPCMessage) {
        discardMessage(message)
    }

    override func pauseOrResumeGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        discardMessage(message)
    }

    override func peerIsConnecting(#message: MPCMessage) {
        discardMessage(message)
    }

    override func peerDidConnect(#message: MPCMessage) {
        discardMessage(message)
    }

    override func peerDidNotConnect(#message: MPCMessage) {
        forwardMessageToController(message)
    }
}

class MultiplayerGameViewInitStatus: MultiplayerGameStatus, GameMessages {

    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        discardMessage(message)
    }

    override func initPlayer(message: MPCMessage) {
        discardMessage(message)
    }

    override func scheduleGame(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidChangeDirection(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidSecureTarget(message: MPCMessage) {
        discardMessage(message)
    }

    override func initTarget(message: MPCMessage) {
        discardMessage(message)
    }

    override func targetWasSecured(message: MPCMessage) {
        discardMessage(message)
    }

    override func targetDidUpdateLocation(message: MPCMessage) {
        discardMessage(message)
    }

    override func pauseOrResumeGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        discardMessage(message)
    }

    override func peerIsConnecting(#message: MPCMessage) {
        discardMessage(message)
    }

    override func peerDidConnect(#message: MPCMessage) {
        discardMessage(message)
    }

    override func peerDidNotConnect(#message: MPCMessage) {
        forwardMessageToController(message)
    }
}

class MultiplayerGameWaitingToScheduleGameStatus: MultiplayerGameStatus, GameMessages {

    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        discardMessage(message)
    }

    override func initPlayer(message: MPCMessage) {
        discardMessage(message)
    }

    override func scheduleGame(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func playerDidChangeDirection(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func playerDidSecureTarget(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func initTarget(message: MPCMessage) {
        discardMessage(message)
    }

    override func targetWasSecured(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func targetDidUpdateLocation(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func pauseOrResumeGame(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func peerIsConnecting(#message: MPCMessage) {
        discardMessage(message)
    }

    override func peerDidConnect(#message: MPCMessage) {
        discardMessage(message)
    }

    override func peerDidNotConnect(#message: MPCMessage) {
        forwardMessageToController(message)
    }
}

class MultiplayerGamePlayingStatus: MultiplayerGameStatus, GameMessages {
    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        discardMessage(message)
    }

    override func initPlayer(message: MPCMessage) {
        discardMessage(message)
    }

    override func scheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func playerDidChangeDirection(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func playerDidSecureTarget(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func initTarget(message: MPCMessage) {
        discardMessage(message)
    }

    override func targetWasSecured(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func targetDidUpdateLocation(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func pauseOrResumeGame(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func peerIsConnecting(#message: MPCMessage) {
        discardMessage(message)
    }

    override func peerDidConnect(#message: MPCMessage) {
        discardMessage(message)
    }

    override func peerDidNotConnect(#message: MPCMessage) {
        forwardMessageToController(message)
    }
}

class MultiplayerGameDidEndStatus: MultiplayerGameStatus, GameMessages {
    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        discardMessage(message)
    }

    override func initPlayer(message: MPCMessage) {
        discardMessage(message)
    }

    override func scheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        println("Ignoring message \(message.description)")
//        discardMessage(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        println("Ignoring message \(message.description)")
//        discardMessage(message)
    }

    override func playerDidChangeDirection(message: MPCMessage) {
        println("Ignoring message \(message.description)")
//        discardMessage(message)
    }

    override func playerDidSecureTarget(message: MPCMessage) {
        discardMessage(message)
    }

    override func initTarget(message: MPCMessage) {
        discardMessage(message)
    }

    override func targetWasSecured(message: MPCMessage) {
        println("Ignoring message \(message.description)")
//        discardMessage(message)
    }

    override func targetDidUpdateLocation(message: MPCMessage) {
        println("Ignoring message \(message.description)")
//        discardMessage(message)
    }

    override func pauseOrResumeGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func peerIsConnecting(#message: MPCMessage) {
        println("Ignoring message \(message.description)")
        //        discardMessage(message)
    }

    override func peerDidConnect(#message: MPCMessage) {
        println("Ignoring message \(message.description)")
        //        discardMessage(message)
    }

    override func peerDidNotConnect(#message: MPCMessage) {
        forwardMessageToController(message)
    }
}