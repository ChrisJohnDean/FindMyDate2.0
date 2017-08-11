//
//  UserTableViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-06-17.
//  Copyright © 2017 Chris Dean. All rights reserved.
//
import Firebase
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class UserTableViewController: UITableViewController {

    
    let userCell = "UserTableViewCell"
    let usersRef = Database.database().reference(withPath: "users")
    var user: FirebaseUser!
    let storageRef = Storage.storage().reference(forURL: "gs://findmydate-1c6f4.appspot.com/")
    //var picture:[UIImage] = []
    //var cart : Dictionary<String, UIImage> = Dictionary<String, UIImage>()
    //var userName: String!
    
    //var currentUsers: [String] = []
    var users : [FirebaseUser] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = FirebaseUser(authData: user)
            
            // Download facebook profile picture to Firebase Storage
            self.usersRef.child(self.user.uid).setValue(["name": self.user.name, "email": self.user.email,
                                                         "profileURL": self.user.profileURL.absoluteString, "uid": self.user.uid])
            let profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300,"width":300,"redirect":false])
            profilePic?.start(completionHandler: {(connection, result, error) -> Void in
                
                if(error == nil)
                {
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.object(forKey: "data")
                    
                    let urlPic = (data as AnyObject).object(forKey: "url") as AnyObject?
                    let url = urlPic as? String ?? ""
                    
                    if let imageData = NSData(contentsOf: NSURL(string: url)! as URL)
                    {
                        let profilePicRef = self.storageRef.child(self.user.uid + "/profile_pic.jpg")
                        
                        let uploadTask = profilePicRef.putData(imageData as Data, metadata:nil){
                            metadata,error in
                            
                            if(error == nil)
                            {
                                let downloadUrl = metadata!.downloadURL
                                
                            }
                            else
                            {
                                print("error in downloading image")
                            }
                        }
                    }
                }
            })
        }
        
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
            
            let row = self.users.count - 1
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .top)
            
            self.tableView.reloadData()

            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//            profilePicRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                if error != nil {
//                    print("an error occurred when downloading profile picture from firebase storage")
//                } else {
//                    
//                    let image = UIImage(data: data!)
//                    //self.picture.append(image!)
//                    self.cart[getDisplayName] = image!
//                    
//                    // tests counts of collections
//                    print(self.cart.count)
//                    
//                    let row = self.cart.count - 1
//                    let indexPath = IndexPath(row: row, section: 0)
//                    self.tableView.insertRows(at: [indexPath], with: .top)
//                    
//                    self.tableView.reloadData()
//                }
//            }
        })
            
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture"]).start {
            (connection, result, err) in
            if err != nil {
                print("Failed to start graph request", err ?? "")
                return
            }
            print(result ?? "")
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return currentUsers.count
    //}

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath) as! UserTableViewCell

        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.reloadInputViews()
        cell.setNeedsLayout()
        
        let profilePicRef = self.storageRef.child(user.uid + "/profile_pic.jpg")
        profilePicRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("an error occurred when downloading profile picture from firebase storage")
            } else {
                let image = UIImage(data: data!)
                cell.picHolder.image = image
                cell.contentView.bringSubview(toFront: cell.picHolder)
                
                self.tableView.reloadData()
            }
            
//            guard let imageData = data, error == nil else {
//                print("an error occurred when retrieving data form storage")
//                return
//            }
//            guard let image = UIImage(data: imageData) else {
//                print("an error occurred when downloading profile picture from firebase storage")
//                return
//            }
//            cell.picHolder.image = image
//            cell.contentView.bringSubview(toFront: cell.picHolder)
//            self.tableView.reloadData()
        }
        
        return cell
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        performSegue(withIdentifier: "cellSegue", sender: cell)
//    }

    
    // Override to perform segue from selected user cell to as the user on a date
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "DateViewController") as! DateViewController
        DvC.user = users[indexPath.row]
        self.navigationController?.pushViewController(DvC, animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
     */
}
