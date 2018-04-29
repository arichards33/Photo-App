//
//  CollectionViewController.swift
//  Photo Phabulous
//
//  Created by Alex Richards on 2/22/18.
//  Copyright © 2018 Alex Richards. All rights reserved.
//"http://www.onlinewebfonts.com/icon"

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    let NetworkingManager = SharedNetworking.shared
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var pictureArray: Pictures?
    private let refresh = UIRefreshControl()
    enum validImage: Error{
        case Empty
    }
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor.magenta
        UINavigationBar.appearance().tintColor = UIColor.black
        self.title = "Photo Phabulous"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        layout.itemSize = CGSize(width: screenWidth/3.1, height: screenWidth/3.1)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 8, left: 2, bottom: 15, right: 2)
        collectionView?.collectionViewLayout = layout
//        self.collectionView?.refreshControl = refresh
//        refresh.addTarget(self, action: #selector(getJSONPictures), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getJSONPictures()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChoosePhoto" {
            let dest = segue.destination as! UIImagePickerViewController
            dest.pictureArray = pictureArray
        }
        
        if segue.identifier == "detailer" {
            let nextStep = segue.destination as! ImageDetailViewController
            do {
                _ = try invalidImage(image: sender as? UIImage)
                nextStep.image = sender as! UIImage
            } catch is validImage{
                print("Image empty")
            }
            catch{
                print("Error")
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let allImages = self.pictureArray{
            print(allImages.results.count)
            return allImages.results.count
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        if (pictureArray?.results != nil) {
            let fullURL = "https://stachesandglasses.appspot.com/" + pictureArray!.results[indexPath.item].image_url!
            print(fullURL)
            
            NetworkingManager.load_image(urlString: fullURL, callback: { (data, success) in
                if success == true{
                    DispatchQueue.main.async {
                        if let image = UIImage(data:data! as Data) {
                            cell.imageView.image = image}
                    }
                }
                else {self.showErrorAlert()}
            })}
        if (pictureArray?.results == nil){
            print("here")
            DispatchQueue.main.async {
                cell.imageView.image = #imageLiteral(resourceName: "addPic")}
        }
        
        return cell
    }
    
    @objc func getJSONPictures(){
        NetworkingManager.getPictures(){(results) in
            if let images = results {self.pictureArray = images}
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                
            }
        }
    }
    
    func showErrorAlert(){
        let networkFail = UIAlertController(title: "Connection Failed", message: "Photo Phabulous cannot connect to the network", preferredStyle: .alert)
        networkFail.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(networkFail, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        let selectedImage = selectedCell.imageView.image
        performSegue(withIdentifier: "detailer", sender: selectedImage)
    }
    
    func invalidImage(image: UIImage?)throws -> String{
        if image == nil{
            throw validImage.Empty}
        else {return("good")}
    }
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
