//
//  ContentView.swift
//  Roomscanner
//
//  Created by Mikael Deurell on 2022-07-13.
//

import SwiftUI
import RoomPlan

struct CaptureView : UIViewRepresentable
{
  @Environment(RoomCaptureController.self) private var captureController

  func makeUIView(context: Context) -> some UIView {
    captureController.roomCaptureView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct ActivityView: UIViewControllerRepresentable {
  var items: [Any]
  var activities: [UIActivity]? = nil
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
    let controller = UIActivityViewController(activityItems: items, applicationActivities: activities)
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}

struct ScanningView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(RoomCaptureController.self) private var captureController
  
  
  var body: some View {
    @Bindable var bindableController = captureController
    
    ZStack(alignment: .bottom) {
      CaptureView()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button("Cancel") {
          captureController.stopSession()
          presentationMode.wrappedValue.dismiss()
        })
        .navigationBarItems(trailing: Button("Done") {
          captureController.stopSession()
          captureController.showExportButton = true
        }.opacity(captureController.showExportButton ? 0 : 1)).onAppear() {
          captureController.showExportButton = false
          captureController.startSession()
        }
      Button(action: {
        captureController.export()
      }, label: {
        Text("Export").font(.title2)
      }).buttonStyle(.borderedProminent)
        .cornerRadius(40)
        .opacity(captureController.showExportButton ? 1 : 0)
        .padding()
        .sheet(isPresented: $bindableController.showShareSheet, content:{
          ActivityView(items: [captureController.exportUrl!]).onDisappear() {
            presentationMode.wrappedValue.dismiss()
          }
        })
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
        Text("Scan the room by pointing the camera at all surfaces. Model export supports usdz format.")
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
