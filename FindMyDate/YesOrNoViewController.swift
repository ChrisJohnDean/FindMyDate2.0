//
//  YesOrNoViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-08-30.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit
import Firebase

class YesOrNoViewController: UIViewController {

    var match: Match!
    let datesRef = Database.database().reference(withPath: "dates")
    var user: FirebaseUser!
   
    @IBOutlet weak var suitor: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBAction func no(_ sender: Any) {
        deleteDate()
        self.navigationController?.popViewController(animated: true)
    }
    //     self.datesRef.child((self.user?.uid)!).child(suitorsUid).setValue(["location": place, "Suitor's Name": suitorsName, "Suitor's Uid": suitorsUid])
    @IBAction func yes(_ sender: Any) {
        let childUpdates = true
        datesRef.child(Auth.auth().currentUser!.uid).child(match.suitorsUid).updateChildValues(["Accepted":childUpdates])
        self.navigationController?.popViewController(animated: true)
    }
//    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = FirebaseUser(authData: Auth.auth().currentUser!)
        suitor.text = match?.suitorsName
        location.text = match?.location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func deleteDate() {
        let matchUid = match?.suitorsUid
        datesRef.child(Auth.auth().currentUser!.uid).child(matchUid!).removeValue(completionBlock: { (error, refer) in
            if error != nil {
                print(error)
            } else {
                print(refer)
                print("Child Removed Correctly")
            }
        })
    }
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
