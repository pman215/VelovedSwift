//
//  OSX_GameLobbyViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/22/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa
import SnakeCommon

class OSX_GameLobbyViewController: NSViewController {

    weak var windowContainer: OSX_MainWindowController?

    @IBOutlet weak var advertisingButton: NSButton!
    @IBOutlet weak var msgField: NSTextField!
    @IBOutlet weak var foundPeersTableView: NSTableView!
    @IBOutlet weak var peerInvitesTableView: NSTableView!
    @IBOutlet weak var messagesTableView: NSTableView!
    var peerInvitesTVC: PeerInvitesTVC!
    var foundPeersTVC: FoundPeersTVC!
    var messagesTVC: MessagesTVC!

    var mode = MPCControllerMode.Advertising

    override func awakeFromNib() {
        configureMPCController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        foundPeersTVC = FoundPeersTVC()
        foundPeersTableView.setDataSource(foundPeersTVC)
        foundPeersTableView.setDelegate(foundPeersTVC)

        peerInvitesTVC = PeerInvitesTVC()
        peerInvitesTableView.setDataSource(peerInvitesTVC)

        messagesTVC = MessagesTVC()
        messagesTableView.setDataSource(messagesTVC)

        registerMPCPeerInvitesDidChangeNotification()
        registerMPCFoundPeersDidChangeNotification()
    }

    func configureMPCController() {

        switch mode {
        case .Advertising:
            println("OSX Game Lobby Start Advertising")
            MPCController.sharedMPCController.setMode(mode)
            MPCController.sharedMPCController.startAdvertising()
        case .Browsing:
            println("OSX Game Lobby Start Browsing")
            MPCController.sharedMPCController.setMode(mode)
            MPCController.sharedMPCController.startBrowsing()
        }

        MPCController.sharedMPCController.delegate = self
    }

    override func viewWillDisappear() {
        unregisterMPCPeerInvitesDidChangeNotification()
        unregisterMPCFoundPeersDidChangeNotification()

        windowContainer?.gameLobby = nil
        windowContainer = nil
    }

    func registerMPCPeerInvitesDidChangeNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updatePeerInvites",
            name: MPCPeerInvitesDidChangeNotification,
            object: MPCController.sharedMPCController)
    }

    func unregisterMPCPeerInvitesDidChangeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: MPCPeerInvitesDidChangeNotification,
            object: MPCController.sharedMPCController)
    }

    func registerMPCFoundPeersDidChangeNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateFoundPeers",
            name: MPCFoundPeersDidChangeNotification,
            object: MPCController.sharedMPCController)
    }

    func unregisterMPCFoundPeersDidChangeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: MPCFoundPeersDidChangeNotification,
            object: MPCController.sharedMPCController)
    }

}

extension OSX_GameLobbyViewController {
    
    @IBAction func toggleAdvertising(sender: NSButton) {
        switch mode {
        case .Advertising:
            MPCController.sharedMPCController.stopAdvertising()
            println("OSX Game Lobby Stop Advertising")

            advertisingButton.title = "Start Advertising"
            mode = .Browsing

        case .Browsing:
            MPCController.sharedMPCController.stopBrowsing()
            println("OSX Game Lobby Stop Browsing")

            advertisingButton.title = "Stop Advertising"
            mode = .Advertising
        }

        configureMPCController()
    }

    @IBAction func invitePeer(sender: NSButton) {
        MPCController.sharedMPCController.invitePeerWithName(foundPeersTVC.selectedPeer)
    }

    @IBAction func sendMsg(sender: NSButton) {
        let msgBody = msgField.stringValue
        let msg = MPCMessage.getTestMessage(msgBody)
        MPCController.sharedMPCController.sendMessage(msg)
    }


    @IBAction func startGame(sender: NSButton) {
        let setUpGameMsg = MPCMessage.getSetUpGameMessage()
        MPCController.sharedMPCController.sendMessage(setUpGameMsg)
        showSnakeGameVC()
    }

    func updatePeerInvites() {

        dispatch_async(dispatch_get_main_queue()) {
            self.peerInvitesTableView.reloadData()
        }
    }

    func updateFoundPeers() {
        dispatch_async(dispatch_get_main_queue()) {
            self.foundPeersTableView.reloadData()
        }
    }

    func showSnakeGameVC() {
        dispatch_async(dispatch_get_main_queue()){
            switch self.mode {
            case .Advertising:
                self.windowContainer?.showMultiplayerMasterSnakeGameVC()
            case .Browsing:
                self.windowContainer?.showMultiplayerSlaveSnakeGameVC()
            }
        }
    }
}

extension OSX_GameLobbyViewController: MPCControllerDelegate {

    func didReceiveMessage(msg: MPCMessage) {
        switch msg.event{
        case .TestMsg:
            var newMsg = [String:String]()
            newMsg[MPCMessageKey.Sender.rawValue] = msg.sender
            newMsg[MPCMessageKey.Receiver.rawValue] = MPCController.sharedMPCController.peerID.displayName
            if let body = msg.body{
                newMsg[MPCMessageKey.TestMsgBody.rawValue] = body[MPCMessageKey.TestMsgBody.rawValue] as? String
            }

            messagesTVC.messages.append(newMsg)
            dispatch_async(dispatch_get_main_queue()) {
                self.messagesTableView.reloadData()
            }
        case .SetUpGame:
            showSnakeGameVC()
        default:
            break
        }
    }
}

class PeerInvitesTVC: NSObject {

}

extension PeerInvitesTVC: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return MPCController.sharedMPCController.getPeerInvites().count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let peerInvite = MPCController.sharedMPCController.getPeerInvites()[row]

        if tableColumn?.identifier == "name" {
            return peerInvite.peerID.displayName
        }else {
            return peerInvite.status.description
        }
    }
}

class FoundPeersTVC: NSObject {
    var selectedPeer: String?
}

extension FoundPeersTVC: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return MPCController.sharedMPCController.getFoundPeers().count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let aPeer = MPCController.sharedMPCController.getFoundPeers()[row]
        return aPeer.displayName
    }
}

extension FoundPeersTVC: NSTableViewDelegate {
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let column = tableView.tableColumns[0] as NSTableColumn
        selectedPeer = self.tableView(tableView, objectValueForTableColumn: column, row: row) as? String
        return true
    }
}

class MessagesTVC: NSObject {
    var messages = [[ String : String ]]()
}

extension MessagesTVC: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return messages.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {

        let rowContent = messages[row]

        return rowContent[tableColumn!.identifier]!
    }
}