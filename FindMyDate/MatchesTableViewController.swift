//
//  MatchesTableViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-07-26.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit
import Firebase

class MatchesTableViewController: UITableViewController {

    let matchCell = "MatchesTableViewCell"
    let datesRef = Database.database().reference(withPath: "dates")
    var user: FirebaseUser!
    let storageRef = Storage.storage().reference(forURL: "gs://findmydate-1c6f4.appspot.com/")
    var dates: [Match] = []
    //var dates = [String: [String: String]]()
    var keys: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = FirebaseUser(authData: Auth.auth().currentUser!)

        //usersRef.observe(.childAdded, with: { snap in
        //let snapValue = snap.value as? NSDictionary
        
//        datesRef.child(self.user.uid).observeSingleEvent(of: .value, with: { snap in
//            self.dates = snap.value as! [String: [String : String]]
//            self.keys = Array(self.dates.keys)
//            
//            let row = self.dates.count - 1
//            let indexPath = IndexPath(row: row, section: 0)
//            self.tableView.insertRows(at: [indexPath], with: .top)
//            self.tableView.reloadData()
//        })
        
        datesRef.child(self.user.uid).observe(.childAdded, with: { snap in
            guard let snapValue = snap.value as? [String: String] else {return}
            let match = Match(suitorsName: snapValue["Suitor's Name"]!, suitorsUid: snapValue["Suitor's Uid"]!, location: snapValue["location"]!)
            self.dates.append(match)
            let row = self.dates.count - 1
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .top)
            self.tableView.reloadData()
        })
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MatchesTableViewCell = tableView.dequeueReusableCell(withIdentifier: matchCell, for: indexPath) as! MatchesTableViewCell
        
//        let key = keys?[indexPath.row]
//        let dict = dates[key!]!
        let match = dates[indexPath.row]
//        cell.textLabel?.text = dict["Suitor's Name"]
//        let suitorsUid = dict["Suitor's Uid"]!
        cell.textLabel?.text = match.suitorsName
        cell.reloadInputViews()
        cell.setNeedsLayout()
        
        let profilePicRef = self.storageRef.child(match.suitorsUid + "/profile_pic.jpg")
        profilePicRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("an error occurred when downloading profile picture from firebase storage")
            } else {
                let image = UIImage(data: data!)
                cell.imageHolder.image = image
                cell.contentView.bringSubview(toFront: cell.imageHolder)
                
                self.tableView.reloadData()
            }
        }
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
