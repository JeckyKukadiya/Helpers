//
//  MultiplayerSession.swift
//  Circle Jerk
//
//  Created by DHARMESH PARMAR on 09/01/24.
//

import Foundation
import MultipeerConnectivity

protocol MultiplayerServiceDelegate {
    func connectedDevicesChanged(manager: MultiplayerService, connectedDevices: [String])
    func didReceiveData(manager: MultiplayerService, data: Data, fromPeer: MCPeerID)
    func updateMyPeerListView(_ peerNames: [String])
}

protocol MultiplayerServiceBrowserDelegate {
    func foundPeer(peerID: MCPeerID, gameName: String)
    func lostPeer(peerID: MCPeerID)
}

class MultiplayerService: NSObject {
    
    //static let shared = MultiplayerService()
    
    private let MultiplayerServiceType = "circlejerk"
    
    private var gameName: String
    private var myPeerName: String
    private var userName: String = ""
    private var myPeerId: MCPeerID
    private var serviceAdvertiser: MCNearbyServiceAdvertiser
    private var serviceBrowser: MCNearbyServiceBrowser
    private var connectedPeers: [MCPeerID] = []
    
    var delegate: MultiplayerServiceDelegate?
    var browserDelegate: MultiplayerServiceBrowserDelegate?
    
    lazy var session: MCSession = {
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()
    
    override init() {
        self.gameName = UIDevice.current.name
        self.myPeerName = UIDevice.current.name
        self.myPeerId = MCPeerID(displayName: UIDevice.current.name)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: MultiplayerServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: MultiplayerServiceType)
        super.init()
    }
    
    func updateGameName(newGameName: String, username: String) {
        // Stop advertising and browsing with the old name
        stopAdvertising()
        stopBrowsing()
        
        // Update the game name and peer ID
        gameName = newGameName
        userName = username
        myPeerId = MCPeerID(displayName: username)
        
        let discoveryInfo = ["gameName": gameName]
        
        // Update advertiser and browser with new peer ID
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: discoveryInfo, serviceType: MultiplayerServiceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: MultiplayerServiceType)
        
        // Restart advertising and browsing with the new name
        startAdvertising()
        startBrowsing()
    }
    
    func updateMyPeerName(peerName: String) {
        stopAdvertising()
        stopBrowsing()
        
        myPeerName = peerName
        userName = peerName
        myPeerId = MCPeerID(displayName: myPeerName)
        
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: MultiplayerServiceType)
        
        startBrowsing()
    }
    
    func startAdvertising() {
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    func startBrowsing() {
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    func stopAdvertising() {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func stopBrowsing() {
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func reinitializeSession() {
        session.delegate = nil // Remove the delegate before discarding the old session
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
    }

    /*
    func startServices() {
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }

    func stopServices() {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }*/

    
    func disconnectAllPeers() {
        session.disconnect()
        connectedPeers.removeAll()
    }
    
    func initiateGetReady() {
        let message = LiveGameModel(type: .gameStarted, data: nil)
        if let messageData = try? JSONEncoder().encode(message) {
            send(data: messageData)
        }
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func send(data: Data) {
        if !session.connectedPeers.isEmpty {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch let error {
                print("Error for sending: \(error)")
            }
        }
    }
    
    func sendPeerListUpdate() {
        var allPeers = connectedPeers

        // Ensure the local peer is always included
        if !allPeers.contains(myPeerId) {
            allPeers.insert(myPeerId, at: 0)  // Add at the start of the list or at a suitable position
        }

        let peerNames = allPeers.map { $0.displayName }

        // Encode peer names as JSON data
        if let peerNamesData = try? JSONEncoder().encode(peerNames) {
            // Wrap the peer names data in your Message struct
            let message = LiveGameModel(type: .peerNames, data: peerNamesData)
            
            // Encode the Message struct as JSON data
            if let messageData = try? JSONEncoder().encode(message) {
                send(data: messageData)
            }
        }
        
        self.delegate?.updateMyPeerListView(peerNames)
    }
    
    func getConnectedPeerNames() -> [String] {
        return connectedPeers.map { $0.displayName }
    }

    func updateGameScore(time: Double, gameName: String) {
        let dict: [String: String] = ["game": gameName, "playerName": userName, "score": "\(Int(time))"]
        print("#DN: sending game score: \(dict)")
        do {
            let resultData = try JSONEncoder().encode(dict)
            let message = LiveGameModel(type: .result, data: resultData)
            let messageData = try JSONEncoder().encode(message)
            send(data: messageData)
        } catch {
            print("#DN: JSON encoding error: \(error)")
        }
    }

    func declareWinner(time: Double, gameName: String) {
        let dict: [String: String] = ["game": gameName, "playerName": userName, "score": "\(Int(time))"]
        print("#DN: sending loser data: \(dict)")
        do {
            let resultData = try JSONEncoder().encode(dict)
            let message = LiveGameModel(type: .loser, data: resultData)
            let messageData = try JSONEncoder().encode(message)
            send(data: messageData)
        } catch {
            print("#DN: JSON encoding error: \(error)")
        }
    }
    
}

extension MultiplayerService: MCSessionDelegate {
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        return certificateHandler(true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("#DN: Connected to \(peerID.displayName)")
            if !connectedPeers.contains(peerID) {
                connectedPeers.append(peerID)
            }
        case .connecting:
            print("#DN: Connecting to \(peerID.displayName)")
        case .notConnected:
            print("#DN: Not connected to \(peerID.displayName)")
            if let index = connectedPeers.firstIndex(of: peerID) {
                connectedPeers.remove(at: index)
            }
        @unknown default:
            print("#DN: Unknown state: \(state)")
        }

        // Notify all peers about the change in connected peers
        sendPeerListUpdate()
        delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map {$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate?.didReceiveData(manager: self, data: data, fromPeer: peerID)
    }
}

extension MultiplayerService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Did not start advertising peer: \(error)")
    }
}

extension MultiplayerService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if let gameName = info?["gameName"] {
            print("Found game: \(gameName) hosted by \(peerID.displayName)")
            browserDelegate?.foundPeer(peerID: peerID, gameName: gameName)
        } else {
            browserDelegate?.foundPeer(peerID: peerID, gameName: "")
        }
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        browserDelegate?.lostPeer(peerID: peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Did not start browsing for peers: \(error)")
    }
    
    func invitePeer(_ peerID: MCPeerID) {
        serviceBrowser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
}
