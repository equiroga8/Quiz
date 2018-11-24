//
//  QuizzesTableViewController.swift
//  Quiz
//
//  Created by Edu Quibra on 20/11/2018.
//  Copyright © 2018 Edu Quibra. All rights reserved.
//

import UIKit

class QuizzesTableViewController: UITableViewController {
    
    var quizzes = [Entities.Quiz]()
    var imageCache = [UIImage]()
    
    @IBAction func refreshQuizzes(_ sender: UIBarButtonItem) {
        downloadData()
    }
    @IBAction func addToFavs(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview as? QuizTableViewCell else {
            print("addFav")
            return
        }
        print("adding FAVV")
        let indexPath = tableView.indexPath(for: cell)
        let isFav = quizzes[(indexPath?.row)!].favourite
        if isFav! {
            quizzes[(indexPath?.row)!].favourite = false
            changeFav(false, quizzes[(indexPath?.row)!])
        } else {
            quizzes[(indexPath?.row)!].favourite = true
            changeFav(true, quizzes[(indexPath?.row)!])
        }
        self.tableView.reloadRows(at: [indexPath!], with: .none)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
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
        print(quizzes.count)
        return quizzes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as? QuizTableViewCell
        cell?.question.text = quizzes[indexPath.row].question
        cell?.author.text = quizzes[indexPath.row].author?.username
        cell?.questionImage.image = imageCache[indexPath.row]
        if quizzes[indexPath.row].favourite! {
            cell?.favourite.setTitle("fav", for: .normal)
        } else {
            cell?.favourite.setTitle("unfav", for: .normal)
        }
        return cell!
    }
    
    private func downloadData(){
        if let url = URL(string: "https://quiz2019.herokuapp.com/api/quizzes?token=114e4dbf7ec490e62b04") {
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
                    if let getQuizzes = try? JSONDecoder().decode(Entities.Quizzes.self, from: data){
                        self.quizzes = getQuizzes.quizzes
                        for quiz in getQuizzes.quizzes {
                            if let imageData = try? Data(contentsOf: (quiz.attachment?.url)!) {
                                if let image = UIImage(data: imageData) {
                                    self.imageCache.append(image)
                                }
                            } else {
                                self.imageCache.append(UIImage(contentsOfFile: "No_Image_Available")!)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("decoder error")
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuiz"{
            if let qVC = segue.destination as? QuizViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    qVC.quiz = quizzes[indexPath.row]
                    qVC.image = imageCache[indexPath.row]
                }
            }
        }
    }
 
    
    private func changeFav(_ changeTo: Bool,_ quiz: Entities.Quiz) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://quiz2019.herokuapp.com/api/users/tokenOwner/favourites/" + String(quiz.id) + "?token=114e4dbf7ec490e62b04")
        var request = URLRequest(url: url!)
        if changeTo {
            request.httpMethod = "PUT"
        } else {
            request.httpMethod = "DELETE"
        }
        print(request.httpMethod!)
        let task = session.dataTask(with: request) {
            (data: Data?, res: URLResponse?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print(HTTPURLResponse.localizedString(forStatusCode: (res as! HTTPURLResponse).statusCode))
        }
        task.resume()
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
