//
//  AudioRoomService.swift
//  voicebox-1-26
//
//  Created by Matthew Fang on 1/26/26.
//

import Foundation
import Observation
import StreamVideo
internal import Combine
import CryptoKit

@Observable
class AudioRoomService {

    // MARK: - Configuration

    let userId: String
    let token: String

    private let apiKey: String = "6yks7w9qurxz"
    private let callId: String = "kk1gLiCOzwYDUhMq98Oqk"

    // MARK: - Activity

    private let activityService: ActivityService

    private static let streamSecret = "7yfxatadshbrtpgg9ttmgpnqenu4j6n956rj278vv6afkk4ebf69jhanuetu3vdm"

    // MARK: - Init

    init(userName: String) {
        self.userId = userName
        self.token = Self.generateToken(for: userName)
        self.activityService = ActivityService(userId: userName)
    }

    private static func generateToken(for userId: String) -> String {
        func base64url(_ data: Data) -> String {
            data.base64EncodedString()
                .replacingOccurrences(of: "+", with: "-")
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: "=", with: "")
        }

        let header = #"{"alg":"HS256","typ":"JWT"}"#
        let payload = #"{"user_id":"\#(userId)"}"#

        let headerB64 = base64url(Data(header.utf8))
        let payloadB64 = base64url(Data(payload.utf8))
        let message = "\(headerB64).\(payloadB64)"

        let key = SymmetricKey(data: Data(streamSecret.utf8))
        let signature = HMAC<SHA256>.authenticationCode(for: Data(message.utf8), using: key)
        let signatureB64 = base64url(Data(signature))

        return "\(message).\(signatureB64)"
    }

    // MARK: - State

    private(set) var isConnected: Bool = false
    private(set) var isLive: Bool = false
    private(set) var participantCount: Int = 0
    private(set) var error: String?

    // MARK: - Private

    private var client: StreamVideo?
    private var call: Call?
    private var observationTask: Task<Void, Never>?
    private var isConnecting: Bool = false

    // MARK: - Lifecycle

    func connect() async {
        // Prevent concurrent connect attempts and don't reconnect if already connected
        guard !isConnected && !isConnecting else { return }
        isConnecting = true
        defer { isConnecting = false }

        // Force cleanup any existing state (handles crash recovery / stale connections)
        await forceCleanup()

        do {
            // Create user
            let user = User(
                id: userId,
                name: userId
            )

            // Initialize Stream Video client
            let client = StreamVideo(
                apiKey: apiKey,
                user: user,
                token: .init(stringLiteral: token)
            )
            self.client = client

            // Create call - use "default" type, not "audio_room"
            // audio_room has backstage mode which blocks non-creators from joining
            // until goLive() is called. "default" allows anyone to join immediately.
            let call = client.call(callType: "default", callId: callId)
            self.call = call

            // Join call (creates if doesn't exist)
            try await call.join(create: true)

            isConnected = true
            isLive = true
            error = nil
            activityService.setActive(true)

            // Observe call state changes
            observationTask = Task { await observeCallState(call) }

        } catch {
            self.error = error.localizedDescription
            isConnected = false
        }
    }

    func disconnect() async {
        // Cancel observation first
        observationTask?.cancel()
        observationTask = nil

        guard isConnected, let call = call else { return }

        do {
            try await call.leave()
        } catch {
            self.error = error.localizedDescription
        }

        self.call = nil
        self.client = nil
        isConnected = false
        isLive = false
        participantCount = 0
        activityService.setActive(false)
    }

    // MARK: - Private

    /// Force cleanup without checking isConnected - handles crash recovery
    private func forceCleanup() async {
        observationTask?.cancel()
        observationTask = nil

        if let call = call {
            try? await call.leave()
        }

        self.call = nil
        self.client = nil
        isConnected = false
        isLive = false
        participantCount = 0
    }

    @MainActor
    private func observeCallState(_ call: Call) async {
        for await _ in call.state.$participants.values {
            guard !Task.isCancelled else { return }
            participantCount = call.state.participants.count
        }
    }
}

