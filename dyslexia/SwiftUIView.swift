//
//  SwiftUIView.swift
//  dyslexia
//
//  Created by ibbi on 5/31/23.
//

import SwiftUI

struct SwiftUIView: View {
    @StateObject private var wsManager = WebSocketManager()

    var body: some View {
        VStack {
            Button("Send Message") {
                wsManager.sendMessage("Hello WebSocket!")
            }

            if let message = wsManager.latestMessage {
                Text("Latest message: \(message)")
            }
        }
        .onAppear {
            wsManager.startConnection()
        }
        .onDisappear {
            wsManager.disconnect()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
