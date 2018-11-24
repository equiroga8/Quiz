//
//  PlayTenViewController.swift
//  Quiz
//
//  Created by Edu Quibra on 24/11/2018.
//  Copyright © 2018 Edu Quibra. All rights reserved.
//

import UIKit

class PlayTenViewController: UIViewController {
    
    var quizzes = [Entities.QuizTen]()
    var imageCache = [UIImage]()
    var scoreNum = 0

    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var questionImage: UIImageView!
    
    @IBAction func checkAns(_ sender: Any) {
        if quizzes[scoreNum].answer == input.text {
            scoreNum = scoreNum + 1
            next()
        } else {
            scoreNum = 0
            imageCache = [UIImage]()
            downloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        

        // Do any additional setup after loading the view.
    }
    
    
    private func downloadData(){
        if let url = URL(string: "https://quiz2019.herokuapp.com/api/quizzes/random10wa?token=114e4dbf7ec490e62b04") {
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
                    if let getQuizzes = try? JSONDecoder().decode([Entities.QuizTen].self, from: data){
                        self.quizzes = getQuizzes
                        for quiz in self.quizzes {
                            if let imageData = try? Data(contentsOf: (quiz.attachment?.url)!) {
                                if let image = UIImage(data: imageData) {
                                    self.imageCache.append(image)
                                }
                            } else {
                                self.imageCache.append(UIImage(contentsOfFile: "No_Image_Available")!)
                            }
                        }
                        DispatchQueue.main.async {
                            self.next()
                        }
                    } else {
                        print("decoder error")
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTips" {
            if let tTVC = segue.destination as? TipsTableViewController {
                tTVC.tips = quizzes[scoreNum].tips!
            }
        }
    }
    
    private func next() {
        question.text = quizzes[scoreNum].question
        questionImage.image = imageCache[scoreNum]
        score.text = "Score: " + String(scoreNum)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
