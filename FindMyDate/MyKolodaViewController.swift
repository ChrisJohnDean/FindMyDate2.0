//
//  MyKolodaViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-08-10.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit
import Koloda
import Firebase

class MyKolodaViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!
    
    let storageRef = Storage.storage().reference(forURL: "gs://findmydate-1c6f4.appspot.com/")
    let usersRef = Database.database().reference(withPath: "users")
    var users : [FirebaseUser] = []
    var images : [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self as! KolodaViewDelegate
        // Do any additional setup after loading the view.
        
        usersRef.observe(.childAdded, with: { snap in
            let snapValue = snap.value as? NSDictionary
            
            guard let getDisplayName = snapValue?["name"] as? String else {return}
            //self.currentUsers.append(getDisplayName)
            
            guard let getProfileURL = snapValue?["profileURL"] as? String else {return}
            let url = NSURL(string: getProfileURL)! as URL
            guard let getEmail = snapValue?["email"] as? String else {return}
            guard let getUid = snapValue?["uid"] as? String else {return}
            //let profilePicRef = self.storageRef.child(getUid + "/profile_pic.jpg")
            
            let user = FirebaseUser(uid: getUid, email: getEmail, name: getDisplayName, profileURL: url)
            self.users.append(user)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension MyKolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return users.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let user = users[Int(index)]
        var profileImage: UIImage!
        
        let profilePicRef = self.storageRef.child(user.uid + "/profile_pic.jpg")
        profilePicRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("an error occurred when downloading profile picture from firebase storage")
            } else {
                profileImage = UIImage(data: data!)!
            }
        }
   
        return UIImageView(image: profileImage)
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView",
                                                  owner: self, options: nil)?[0] as? OverlayView
    }
}
