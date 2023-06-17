//
//  PanoramaViewController.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 4/25/23.
//

import UIKit
import ARKit
import AVFoundation

class PanoramaViewController: UIViewController, ARSessionDelegate, AVCaptureDepthDataOutputDelegate {
//    var session: ARSession!
//    var captureSession: AVCaptureSession!
//    var depthOutput: AVCaptureDepthDataOutput!
//    var depthPixelBuffer: CVPixelBuffer?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        session = ARSession()
//        session.delegate = self
//        
//        let captureDevice = AVCaptureDevice.default(for: .video)
//        let input = try! AVCaptureDeviceInput(device: captureDevice!)
//        
//        captureSession = AVCaptureSession()
//        captureSession.addInput(input)
//        
//        depthOutput = AVCaptureDepthDataOutput()
//        depthOutput.setDelegate(self, callbackQueue: DispatchQueue.global(qos: .userInteractive))
//        
//        if captureSession.canAddOutput(depthOutput) {
//            captureSession.addOutput(depthOutput)
//            depthOutput.connection(with: .depthData)?.isEnabled = true
//            depthOutput.isFilteringEnabled = true
//        }
//        
//        captureSession.startRunning()
//    }
//    
//    func capturePhoto() {
//        let settings = AVCapturePhotoSettings()
//        settings.isDepthDataDeliveryEnabled = true
//        settings.embedsDepthDataInPhoto = true
//        settings.depthDataQuality = .high
//        settings.depthDataFiltered = true
//        settings.depthDataMinFrameDuration = CMTimeMake(value: 1, timescale: 15)
//        settings.depthDataMaxFrameRate = 15
//        
//        // Set the minimum and maximum depth values here...
//        settings.depthDataMinReliableDistance = 0.1
//        settings.depthDataMaxReliableDistance = 10.0
//        
//        let photoOutput = AVCapturePhotoOutput()
//        photoOutput.capturePhoto(with: settings, delegate: self)
//    }
//    
//    func blendImages(image1: UIImage, image2: UIImage) -> UIImage? {
//        let size = CGSize(width: max(image1.size.width, image2.size.width), height: max(image1.size.height, image2.size.height))
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//        
//        let rect1 = CGRect(x: 0, y: 0, width: image1.size.width, height: image1.size.height)
//        let rect2 = CGRect(x: 0, y: 0, width: image2.size.width, height: image2.size.height)
//        
//        image1.draw(in: rect1)
//        image2.draw(in: rect2, blendMode: .normal, alpha: 0.5)
//        
//        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
//        
//        UIGraphicsEndImageContext()
//        
//        return blendedImage
//    }
//    
//    func captureOutput(_ output: AVCaptureOutput, didOutput depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {
//        let pixelBuffer = depthData.depthDataMap
//        
//        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
//        
//        let width = CVPixelBufferGetWidth(pixelBuffer)
//        let height = CVPixelBufferGetHeight(pixelBuffer)
//        
//        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
//        let context = CIContext(options: nil)
//        
//        if let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: width, height: height)) {
//            let uiImage1 = UIImage(cgImage: cgImage)
//            
//            // Capture another photo here...
//            capturePhoto()
//            
//            // Combine all the images together using image processing techniques such as blending or averaging.
//            let blendedImage = blendImages(image1: uiImage1!, image2: uiImage!)
//            
//            // Save the blended image here...
//            if let imageData = blendedImage?.jpegData(compressionQuality: 1.0) {
//                try? imageData.write(to: URL(fileURLWithPath:"/path/to/save/image.jpg"))
//            }
//            
//            // Display the blended image here...
//            DispatchQueue.main.async {
//                imageView.image = blendedImage
//            }
//            
//            // Release the pixel buffer lock.
//            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
//            
//            // Set the new captured photo as the first photo for the next blending operation.
//            uiImage1 = uiImage!
//            
//            // Capture another photo here...
//            capturePhoto()
//            
//            // Combine all the images together using image processing techniques such
//            // Wait for a few seconds to ensure that all the photos are captured.
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                        
//                        // Read the second captured photo from the file system.
//                        if let image2 = UIImage(contentsOfFile: "/path/to/save/image2.jpg") {
//                            
//                            // Combine the first and second photos using image processing techniques such as blending or averaging.
//                            let blendedImage2 = blendImages(image1: uiImage1!, image2: image2)
//                            
//                            // Save the blended image here...
//                            if let imageData2 = blendedImage2?.jpegData(compressionQuality: 1.0) {
//                                try? imageData2.write(to: URL(fileURLWithPath:"/path/to/save/image2.jpg"))
//                            }
//                            
//                            // Display the blended image here...
//                            DispatchQueue.main.async {
//                                imageView.image = blendedImage2
//                            }
//                            
//                            // Release the pixel buffer lock.
//                            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
//                            
//                            // Set the new captured photo as the first photo for the next blending operation.
//                            uiImage1 = blendedImage2!
//                            
//                            // Capture the fourth photo here...
//                            capturePhoto()
//                            
//                            // Wait for a few seconds to ensure that all the photos are captured.
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                                
//                                // Read the third captured photo from the file system.
//                                if let image3 = UIImage(contentsOfFile: "/path/to/save/image3.jpg") {
//                                    
//                                    // Combine the first, second and third photos using image processing techniques such as blending or averaging.
//                                    let blendedImage3 = blendImages(image1: uiImage1!, image2: image3)
//                                    
//                                    // Save the blended image here...
//                                    if let imageData3 = blendedImage3?.jpegData(compressionQuality: 1.0) {
//                                        try? imageData3.write(to: URL(fileURLWithPath:"/path/to/save/image3.jpg"))
//                                    }
//                                    
//                                    // Display the blended image here...
//                                    DispatchQueue.main.async {
//                                        imageView.image = blendedImage3
//                                    }
//                                    
//                                    // Release the pixel buffer lock.
//                                    CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
//                                    
//                                    // Use the blended image as the input for the AI generated design.
//                                    useImageForAIDesign(image: blendedImage3!)
//                                    
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//    
//    func averageImages(image1: UIImage, image2: UIImage) -> UIImage? {
//        let size = CGSize(width: max(image1.size.width, image2.size.width), height: max(image1.size.height, image2.size.height))
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//        
//        let rect1 = CGRect(x: 0, y: 0, width: image1.size.width, height: image1.size.height)
//        let rect2 = CGRect(x: 0, y: 0, width: image2.size.width, height: image2.size.height)
//        
//        let context = UIGraphicsGetCurrentContext()!
//        
//        context.setBlendMode(.normal)
//        context.setAlpha(0.5)
//        
//        context.draw(image1.cgImage!, in: rect1)
//        context.draw(image2.cgImage!, in: rect2)
//        
//        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
//        
//        UIGraphicsEndImageContext()
//        
//        return blendedImage
//    }
}
