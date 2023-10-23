//
//  RoomCaptureController.swift
//  Roomscanner
//
//  Created by Mikael Deurell on 2022-07-14.
//

import Foundation
import RoomPlan
import Observation

@Observable 
class RoomCaptureController: RoomCaptureViewDelegate, RoomCaptureSessionDelegate, ObservableObject
{
  var roomCaptureView: RoomCaptureView
  var showExportButton = false
  var showShareSheet = false
  var exportUrl: URL?
  
  var sessionConfig: RoomCaptureSession.Configuration
  var finalResult: CapturedRoom?
  
  init() {
    roomCaptureView = RoomCaptureView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
    sessionConfig = RoomCaptureSession.Configuration()
    roomCaptureView.captureSession.delegate = self
    roomCaptureView.delegate = self
  }
  
  func startSession() {
    roomCaptureView.captureSession.run(configuration: sessionConfig)
  }
  
  func stopSession() {
    roomCaptureView.captureSession.stop()
  }
  
  func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
    return true
  }
  
  func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
    finalResult = processedResult
  }
  
  func export() {
    exportUrl = FileManager.default.temporaryDirectory.appending(path: "scan.usdz")
    do {
      try finalResult?.export(to: exportUrl!)
    } catch {
      print("Error exporting usdz scan.")
      return
    }
    showShareSheet = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not needed.")
  }
  
  func encode(with coder: NSCoder) {
    fatalError("Not needed.")
  }
}
