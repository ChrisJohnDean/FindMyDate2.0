//
//  DateViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-07-04.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit
import Firebase

class DateViewController: UIViewController {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var dateeName: UILabel!

    
    var user: FirebaseUser?
    var suitorsName: String!
    var suitorsUid: String!
    let datesRef = Database.database().reference(withPath: "dates")
    let usersRef = Database.database().reference(withPath: "users")
    var place: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateeName.text = user?.name
        
        let userID = Auth.auth().currentUser?.uid
        usersRef.child(userID!).observeSingleEvent(of: .value, with: { snap in
            let value = snap.value as? NSDictionary
            self.suitorsName = value?["name"] as? String ?? ""
            self.suitorsUid = value?["uid"] as? String ?? ""
        })
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func swipeAction(swipe: UISwipeGestureRecognizer) -> Void {
        if swipe.direction == UISwipeGestureRecognizerDirection.right {
            place = location.text
            print(place)
            print(suitorsUid)
            print(suitorsName)
            self.datesRef.child((self.user?.uid)!).child(suitorsUid).setValue(["location": place, "Suitor's Name": suitorsName, "Suitor's Uid": suitorsUid])
            self.navigationController?.popViewController(animated: true)
        }
        else {
            return
        }
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


