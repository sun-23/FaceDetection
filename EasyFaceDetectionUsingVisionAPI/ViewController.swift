//
//  ViewController.swift
//  EasyFaceDetectionUsingVisionAPI
//
//  Created by sun on 4/5/2562 BE.
//  Copyright © 2562 sun. All rights reserved.
//

import UIKit
import Vision
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
      

// /---------------------------------------------------------------------------------------------------/
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Button1(_ sender: UIButton) {
        
       
        
        print("YOU CLICK B1")
        guard let image = UIImage(named: "sample1") else {return}
        
        FaceDetection(imageFace: image)
        
    }
     @IBAction func Button2(_ sender: UIButton) {
        
        print("YOU CLICK B2")
        
        
        
        guard let image = UIImage(named: "sample2") else {return}
        
        FaceDetection(imageFace: image)
       
    }
    
   
    @IBAction func clearBTN(_ sender: UIButton) {
        
        for v in view.subviews{
            if v is UIImageView , v is UIView {
                v.removeFromSuperview()   // ล้างภาพ
            }
        }
        FaceView?.forEach({$0.removeFromSuperview()}) // ล้างตัวจับภาพ
        
        
    }
    
    
    
    @IBAction func button3(_ sender: Any) {
        
        
        guard let image = UIImage(named: "sample3") else {return}
        
        FaceDetection(imageFace: image)
    
    }
     @IBAction func button4(_ sender: Any) {
        
        
        guard let image = UIImage(named: "sample4") else {return}
        
        
        FaceDetection(imageFace: image)
        
    }
    
    
    @IBAction func button5(_ sender: Any) {
        
        
        guard let image = UIImage(named: "sample5") else {return}
        
       FaceDetection(imageFace: image)
        
    }
    
    
    
    var FaceView: [UIView]? // เป็น UIView
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
 
    
    
    func FaceDetection(imageFace:UIImage) {
        
        FaceView?.forEach({$0.removeFromSuperview()}) // ล้างตัวจับภาพ
        
        for v in view.subviews{
            if v is UIImageView , v is UIView {
                v.removeFromSuperview() // ล้างภาพ
            }
        }
        
        
        let image = imageFace
        
         imageView.image =  imageFace
        
        let sceledHeight = view.frame.width / image.size.width * image.size.height
         let imageScaledHeight = view.frame.size.width / image.size.width * image.size.height
        
        
        imageView.frame = CGRect(x: 0, y: view.frame.height - ( view.frame.height / 2 + sceledHeight / 2 ), width: view.frame.width, height: sceledHeight)
        
        imageView.backgroundColor = .black
        
        view.backgroundColor = .black
        
        
        view.addSubview(imageView)
        
        // face detection /-------------------------------------------------------------------------/
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
               self.FaceView = [] // FaceView เป็น array ที่ให้ detectView ไปใส่ค่าใน FaceView ที่เป็น UIView
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    
                    guard let faceObservation = res as? VNFaceObservation else {return}
                    
                    
                    let rect = faceObservation.boundingBox
                    
                    let transformFlip = CGAffineTransform.init(scaleX: 1, y: -1).translatedBy(x: 0, y: -imageScaledHeight - self.view.frame.height / 2  + imageScaledHeight / 2)
                    let transformScale = CGAffineTransform.identity.scaledBy(x: self.view.frame.width, y: imageScaledHeight)
                    let converted_rect = rect.applying(transformScale).applying(transformFlip)
                    
                    // ระบุตำแหน่งของ faceObservation
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let height = sceledHeight * faceObservation.boundingBox.height
                    let y = sceledHeight  * (1 - faceObservation.boundingBox.origin.y) + height
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    
                    
                    let detectView = UIView()
                    
                    
                    detectView.layer.borderColor = UIColor.red.cgColor
                    detectView.layer.borderWidth = 2
                    detectView.layer.cornerRadius = 8
                    detectView.backgroundColor = UIColor(white: 1, alpha: 0.5)
                    detectView.frame = CGRect(x: x, y: y, width: width, height: height)
                    
                    // self.view.addSubview(detectView) // เพิ่ม detectView ใน view
                    
                  //  self.FaceView?.append(detectView) // เพิ่ม detectView ใน FaceView
                    print(faceObservation.boundingBox)
                    
                    
                    let redView = UIView()
                    redView.layer.borderColor = UIColor.red.cgColor
                    redView.layer.borderWidth = 2
                    redView.layer.cornerRadius = 8
                    redView.frame = converted_rect
                    redView.backgroundColor = UIColor(white: 1, alpha: 0.5)
                    self.view.addSubview(redView)
                    
                    redView.layer.transform = CATransform3DMakeScale(0, 0, 0)
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        redView.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    }, completion: nil)
                    
                    self.FaceView?.append(redView)
                }
                
            })
            
        }
        
        guard let cgImage = image.cgImage else {return}
        
        DispatchQueue.global(qos: .background).async {
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do{
                try handler.perform([request])
                
            } catch let reqErr{
                
                print("Failed to perform request:", reqErr)
                
            }
        }
        
        
        // /---------------------------------------------------------------------------------------------------/
        
        // Do any additional setup after loading the view.
        
    }
    
}

