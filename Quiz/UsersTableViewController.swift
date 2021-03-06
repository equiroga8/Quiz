//
//  UsersTableViewController.swift
//  Quiz
//
//  Created by Edu Quibra on 17/11/2018.
//  Copyright © 2018 Edu Quibra. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    var users = [Entities.User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = "User: " + users[indexPath.row].username
        cell.detailTextLabel?.text = "ID: "+String(users[indexPath.row].id)

        return cell
    }
    
    private func downloadData(){
        if let url = URL(string: "https://quiz2019.herokuapp.com/api/users?token=114e4dbf7ec490e62b04") {
            let queue = DispatchQueue(label: "Download Queue")
            queue.async {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                defer {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
                if let data = try? Data(contentsOf: url){
                    if let authors = try? JSONDecoder().decode([Entities.User].self, from: data){
                        self.users = authors
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
