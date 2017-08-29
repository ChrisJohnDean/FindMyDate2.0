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
import pop

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private var numberOfCards: Int = 5

class MyKolodaViewController: UIViewController {

    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    let storageRef = Storage.storage().reference(forURL: "gs://findmydate-1c6f4.appspot.com/")
    let usersRef = Database.database().reference(withPath: "users")
    var users = Array<FirebaseUser>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self// as? KolodaViewDelegate
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        fetchPhotos() {
            (_: [FirebaseUser]) in
            print("fetched urls")
        }

    }
    

    
    func fetchPhotos(completion: @escaping (Array<FirebaseUser>) -> ()) {
        //DispatchQueue.main.async {
        //var users: Array<FirebaseUser> = []
        self.usersRef.observe(.value, with: {snap in
            var users = Array<FirebaseUser>()
            
            if let snapshots = snap.children.allObjects as? [DataSnapshot] {
                for snapShot in snapshots {
                    guard let getName = snapShot.childSnapshot(forPath: "name").value! as? String else {return}
                    guard let getProfileURL = snapShot.childSnapshot(forPath: "profileURL").value! as? String else {return}
                    let url = NSURL(string: getProfileURL)! as URL
                    guard let getEmail = snapShot.childSnapshot(forPath: "email").value! as? String else {return}
                    guard let getUid = snapShot.childSnapshot(forPath: "uid").value! as? String else {return}
                    let user = FirebaseUser(uid: getUid, email: getEmail, name: getName, profileURL: url)
                    users.append(user)
                    
                    //print(users.count)
                }
            }
            self.users = users
            self.kolodaView.reloadData()
            completion(users)
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        kolodaView?.swipe(SwipeResultDirection.left)
        
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        
        var currentIndex = (kolodaView.currentCardIndex )
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "DateViewController") as! DateViewController
        DvC.user = self.users[currentIndex]
        self.navigationController?.pushViewController(DvC, animated: true)
        //self.kolodaView.reloadData()
        print("swiped right")
        kolodaView?.swipe(SwipeResultDirection.right)
        
        
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

extension MyKolodaViewController: KolodaViewDelegate {
    
    func kolodaDidSwipedCardAtIndex(_ koloda: KolodaView, index: Int, direction: SwipeResultDirection) {
        print("ahh")
        DispatchQueue.main.async() {
        if direction == .right {
            print("swiped right")
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let DvC = Storyboard.instantiateViewController(withIdentifier: "DateViewController") as! DateViewController
            DvC.user = self.users[Int(index)]
            self.navigationController?.pushViewController(DvC, animated: true)
            self.kolodaView.reloadData()
            print("swiped right")
//            DispatchQueue.main.async() {
//                self.kolodaView.reloadData()
//            }
        }
        }
        self.kolodaView.reloadData()
        
        
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //Example: reloading
        kolodaView.resetCurrentCardIndex()
        fetchPhotos() {
            (_: [FirebaseUser]) in
            print("fetched urls")
        }
     
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    

    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
}

extension MyKolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        print(self.users.count)
        return self.users.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let photoView = Bundle.main.loadNibNamed("KolodaPhotoView", owner: self, options: nil)?[0] as? KolodaPhotoView
        //var photoView: KolodaPhotoView?
        let user = users[Int(index)]
        photoView?.photoImage?.imageFromURL(user.profileURL.absoluteString)
        photoView?.photoTitle?.text = user.name
        print(user.name)
        print(user.profileURL.absoluteString) 
        return photoView!
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView",
                                                  owner: self, options: nil)?[0] as? OverlayView
    }
}
