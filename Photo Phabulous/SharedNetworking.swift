//
//  SharedNetworking.swift
//  Photo Phabulous
//
//  Created by Alex Richards on 2/21/18.
//  Copyright © 2018 Alex Richards. All rights reserved.
//

import Foundation
import UIKit

class SharedNetworking {
    
    static let shared = SharedNetworking()
    let cache = NSCache<NSString, NSData>()
    let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let fileManager = FileManager()
    let documentDirectory: URL?
    let jsonFile: URL?
    
    enum apiURL: String{
        case get = "https://stachesandglasses.appspot.com/user/amrichards33/json/"
        case post = "https://stachesandglasses.appspot.com/post/amrichards33/"
    }
    
    
    init(){
        do {
            documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            jsonFile = documentDirectory?.appendingPathComponent("PhotoPhabulous.json")
        }
        catch {
            print(error)
            documentDirectory = nil
            jsonFile = nil
        }
    }
    
    func getPictures(completion:@escaping (Pictures?) -> Void) {
        let decoder = JSONDecoder()
        
        if fileManager.fileExists(atPath: jsonFile!.path){
            do {
                let readFile = try Data(contentsOf: jsonFile!)
                let savedPicture = try decoder.decode(Pictures.self, from: readFile)
                completion(savedPicture)
                return
            } catch  {
                print(error)
            }
        }
        
        guard let url = NSURL(string: apiURL.get.rawValue) else {
            fatalError("Unable to create NSURL from string")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            print(" THIS IS THE ERROR: \(error)")
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let picture = try decoder.decode(Pictures.self, from: data)
                try data.write(to: self.jsonFile!)
                completion(picture)
            } catch {
                print("Error serializing/decoding JSON: \(error)")
            }
        })
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        task.resume()
    }
    
    func uploadPicture(user: NSString, image: UIImage) {
        
        let boundary = generateBoundaryString()
        //let scaledImage = resize(image: image, scale: 0.5)
        let imageJPEGData = UIImageJPEGRepresentation(image,0.1)
        
        guard let imageData = imageJPEGData else {return}
        
        // Create the URL, the user should be unique
        let url = NSURL(string: apiURL.post.rawValue)
        
        // Create the request
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Set the type of the data being sent
        let mimetype = "image/jpeg"
        // This is not necessary
        let fileName = "img1.jpg"
        
        // Create data for the body
        let body = NSMutableData()
        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        // Caption data
        body.append("Content-Disposition:form-data; name=\"caption\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("CaptionText\r\n".data(using: String.Encoding.utf8)!)
        
        // Image data
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        // Trailing boundary
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        // Set the body in the request
        request.httpBody = body as Data
        
        // Create a data task
        let session = URLSession.shared
        
    
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // Need more robust errory handling here
            // 200 response is successful post
            
            if error != nil {
                print(error as Any)

            } else {
                print(response!)
                if self.fileManager.fileExists(atPath: self.jsonFile!.path){
                    do {
                        try self.fileManager.removeItem(at: self.jsonFile!)
                    } catch {
                        print(error)
                    }
                }
                //print(error)
                
                // The data returned is the update JSON list of all the images
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString!)
                //completion(true)
                
            }
        }
        
        task.resume()
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func load_image(urlString:String, callback:@escaping ((_ imageData: NSData?, _ success: Bool) -> Void ))
    {
        let imgURL: URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url: imgURL as URL)
        if let cachedVersion = cache.object(forKey: urlString as NSString){
            callback(cachedVersion as NSData, true)
        } else {
            URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                if error == nil {
                    self.cache.setObject(data! as NSData, forKey: urlString as NSString)
                    callback(data! as NSData, true)
                }
                else {callback(nil, false)}
            }.resume()
        }
    }
    
}
