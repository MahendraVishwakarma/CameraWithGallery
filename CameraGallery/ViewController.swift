//
//  ViewController.swift
//  CameraGallery
//
//  Created by Mahendra Vishwakarma on 25/02/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class imageCell:UICollectionViewCell{
    @IBOutlet weak var image: UIImageView!
    
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

   // var photos = [UIImage]()
    var photos : PHFetchResult<PHAsset>?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        setupCaptureSession()
        setupDevice(cameraType: AVCaptureDevice.Position.front)
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
           self.photos = images
            self.collectionView.reloadData()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = photos?.count else{
         return 0
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imageCell
        
        let assest = photos?.object(at: indexPath.row)
        
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .fast
        options.deliveryMode = .opportunistic
        options.isSynchronous = true
        options.isNetworkAccessAllowed = false
        
        PHImageManager.default().requestImageData(for: assest!, options: options) {
                            data, uti, orientation, info in
            
                            guard let data =  data else{
                                return
                            }
            
                            guard let image = UIImage(data: data) else{
                                return
                            }
            
                         cell.image.image = image
            
                        }
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! imageCell
        imageiew.image = cell.image.image
    }
    
    func setupCaptureSession(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }

    func setupDevice(cameraType:AVCaptureDevice.Position){
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == cameraType{
                currentCamera = device
                break
            }
        }
        
       // currentCamera = backCamera
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
    
    
    
    @IBAction func swapButton(_ sender: Any) {
       
        captureSession.removeInput(captureSession.inputs.first!)
        cameraPreviewLayer?.removeFromSuperlayer()
        
        let camera = currentCamera?.position == AVCaptureDevice.Position.back ? AVCaptureDevice.Position.front:AVCaptureDevice.Position.back
        
        setupCaptureSession()
        setupDevice(cameraType: camera)
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
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
