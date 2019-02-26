//
//  ViewController.swift
//  CameraGallery
//
//  Created by Mahendra Vishwakarma on 25/02/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import AVFoundation


class imageCell:UICollectionViewCell{
    @IBOutlet weak var image: UIImageView!
    
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var photos = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        

    }
    @IBOutlet weak var imageiew: UIImageView!
    
    var captureSession = AVCaptureSession()
    var backCamera : AVCaptureDevice?
    var frontCamera : AVCaptureDevice?
    var currentCamera : AVCaptureDevice?
    var photoOutput : AVCapturePhotoOutput?
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        PHAssestLib.fetchImage { (images) in
            self.photos.append(contentsOf: images)
            self.collectionView.reloadData()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imageCell
        cell.image.image = photos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageiew.image = photos[indexPath.row]
    }
    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }

    func setupDevice(){
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            }else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    func setupInputOutput(){
        
        do{
            if(currentCamera != nil){
                let captureDeviceInput =  try AVCaptureDeviceInput(device: currentCamera!)
                captureSession.addInput(captureDeviceInput)
                photoOutput = AVCapturePhotoOutput()
                photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
                captureSession.addOutput(photoOutput!)
            }
            
        }catch let error{
            print(error)
        }
    }
    
    func setupPreviewLayer(){
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewLayer?.frame = self.view.bounds
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        
    }
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    
    @IBAction func captureImage(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        
        
    }
}

extension ViewController:AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            imageiew.image = UIImage(data: imageData)
            
        }
    }
}
