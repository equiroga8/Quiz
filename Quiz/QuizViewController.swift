//
//  QuizViewController.swift
//  Quiz
//
//  Created by Edu Quibra on 24/11/2018.
//  Copyright © 2018 Edu Quibra. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    var quiz: Entities.Quiz?
    var image: UIImage?
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var tips: UIButton!
    @IBOutlet weak var confirm: UIButton!
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        let answer = input.text?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let quizId = quiz?.id
        guard let url = URL(string:"https://quiz2019.herokuapp.com/api/quizzes/" + String(quizId!) + "/check?answer=" + answer! + "&token=114e4dbf7ec490e62b04" ) else {
            print("error URL")
            return
        }
        if let data = try? Data(contentsOf: url){
            if let getAns = try? JSONDecoder().decode(Entities.Answer.self, from: data){
                if getAns.result {
                    view.backgroundColor = UIColor.green.withAlphaComponent(0.5)
                } else {
                    view.backgroundColor = UIColor.red.withAlphaComponent(0.5)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        question.text = quiz?.question
        quizImage.image = image
        
        if quiz?.tips?.count == 0 {
            tips.isHidden = true
        }

    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTips" {
            if let tTVC = segue.destination as? TipsTableViewController {
                tTVC.tips = (quiz?.tips)!
            }
        }
    }
    

}
