//
//  ImageDetailViewController.swift
//  Photo Phabulous
//
//  Created by Alex Richards on 2/24/18.
//  Copyright © 2018 Alex Richards. All rights reserved.
//
import Social
import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var socialShare: UIBarButtonItem!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDetail.frame = UIScreen.main.bounds
        imageDetail.contentMode = .scaleAspectFit
        imageDetail.image = image
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sharePicture(){
        if let social = SLComposeViewController(forServiceType: SLServiceTypeTwitter){
            social.add(image)
            social.add(URL(string: "https://google.com"))
            self.present(social, animated: true)
        } else {
            showTwitterAlert()
        }
    }
    
    func showTwitterAlert(){
        let TwitterFail = UIAlertController(title: "Sharing Failed", message: "Can not connect to Twitter", preferredStyle: .alert)
        TwitterFail.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(TwitterFail, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
