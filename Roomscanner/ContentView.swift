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
  @StateObject var captureController = RoomCaptureController.instance
  
  var body: some View {
    ZStack(alignment: .bottom) {
      RoomCaptureViewRep()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button("Cancel") {
          captureController.stopSession()
          dismiss()
        })
        .navigationBarItems(trailing: Button("Done") {
          captureController.stopSession()
          captureController.showExportButton = true
        }).onAppear() {
          captureController.showExportButton = false
          captureController.startSession()
        }
      Button(action: {
        captureController.export()
      }, label: {
        Text("Export").font(.title2)
      }).buttonStyle(.borderedProminent).cornerRadius(40).opacity(captureController.showExportButton ? 1 : 0).padding()
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
        Text("Roomscanner").font(.title)
        Spacer().frame(height: 40)
        Text("Scan the room by pointing the camera at all surfaces. Model export supports usdz and obj format.")
        Spacer().frame(height: 40)
        NavigationLink(destination: ScanningView(), label: {Text("Start Scan")}).buttonStyle(.borderedProminent).cornerRadius(40).font(.title2)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
