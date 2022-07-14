//
//  ContentView.swift
//  Roomscanner
//
//  Created by Mikael Deurell on 2022-07-13.
//

import SwiftUI
import RoomPlan

struct RoomCaptureViewRep : UIViewRepresentable
{
  func makeUIView(context: Context) -> some UIView {
    RoomCaptureController.instance.roomCaptureView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
  }
}

struct ScanningView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject var roomCaptureController = RoomCaptureController.instance
  
  var body: some View {
    RoomCaptureViewRep()
      .navigationBarBackButtonHidden(true)
      .navigationBarItems(leading: Button("Cancel") {
        roomCaptureController.stopSession()
        dismiss()
      })
      .navigationBarItems(trailing: Button("Done") {
        // done scanning
        roomCaptureController.stopSession()
      }).onAppear() {
        roomCaptureController.startSession()
      }
  }
}

struct ContentView: View {
  var body: some View {
    NavigationStack {
      VStack {
        Image(systemName: "camera.metering.matrix")
          .imageScale(.large)
          .foregroundColor(.accentColor)
        Text("Roomscanner").bold().font(.title)
        Spacer().frame(height: 40)
        Text("Scan the room by pointing the camera at all surfaces. Model export supports usdz and obj format.")
        Spacer().frame(height: 40)
        NavigationLink(destination: ScanningView()) {
          Text("Start scanning")
        }.buttonStyle(.bordered)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
