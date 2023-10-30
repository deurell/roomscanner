//
//  RoomscannerApp.swift
//  Roomscanner
//
//  Created by Mikael Deurell on 2022-07-13.
//

import SwiftUI

@main
struct RoomscannerApp: App {
  static let captureController = RoomCaptureController()
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(RoomscannerApp.captureController)
    }
  }
}
