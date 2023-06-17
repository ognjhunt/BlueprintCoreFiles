////
////  ObjectCaptureViewController.swift
////  Indoor Blueprint
////
////  Created by Nijel Hunt on 6/11/23.
////
//
//import RealityKit
//import SwiftUI
//
//struct CapturePrimaryView: View {
//    var body: some View {
//        ZStack {
//            ObjectCaptureView(session: session)
//        }
//    }
//}
//
//class ObjectCaptureViewController: UIViewController {
//
//    var session = ObjectCaptureSession()
//
//    var body: some View {
//        ZStack {
//            ObjectCaptureView(session: session)
//            if case .ready = session.state {
//                CreateButton(label: "Continue") {
//                    session.startDetecting()
//                }
//            } else if case .detecting = session.state {
//                CreateButton(label: "Start Capture") {
//                    session.startCapturing()
//                }
//            }
//        }
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        var configuration = ObjectCaptureSession.Configuration()
//        configuration.checkpointDirectory = getDocumentsDir().appendingPathComponent("Snapshots/")
//
//        session.start(imagesDirectory: getDocumentsDir().appendingPathComponent("Images/"),
//                      configuration: configuration)
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
