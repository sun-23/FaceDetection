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
        
        guard let image = UIImage(named: "sample5") else {return}
        
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let sceledHeight = view.frame.width / image.size.width * image.size.height
        
        
        imageView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: sceledHeight)
        
        imageView.backgroundColor = .black
        
        view.backgroundColor = .black
        
        view.addSubview(imageView)
        
        // face detection /-------------------------------------------------------------------------/
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
           
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    
                    guard let faceObservation = res as? VNFaceObservation else {return}
                    
                    // ระบุตำแหน่งของ faceObservation
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let height = sceledHeight * faceObservation.boundingBox.height
                    let y = sceledHeight * (1 - faceObservation.boundingBox.origin.y) - ( 0.4 * height)
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    
                    let redView = UIView()
                    redView.backgroundColor = .white
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    
                    self.view.addSubview(redView)
                    print(faceObservation.boundingBox)
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

