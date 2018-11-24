//
//  Codables.swift
//  Quiz
//
//  Created by Edu Quibra on 17/11/2018.
//  Copyright © 2018 Edu Quibra. All rights reserved.
//

import Foundation
class Entities {
    struct User: Codable {
        var id: Int
        var isAdmin: Bool?
        var username: String
    }
    
    struct Quizzes: Codable {
        var quizzes: [Quiz]
        var pageno: Int
        var nextURL: URL?
    }
    
    struct Quiz: Codable {
        var id: Int
        var question: String
        var author: User?
        var attachment: Attachment?
        var favourite: Bool?
        var tips: [String]?
    }
    
    struct Attachment: Codable {
        var filename: String
        var mime: String
        var url: URL
    }
    
    struct Answer: Codable {
        var quizId: Int
        var answer: String
        var result: Bool
    }
    
    struct QuizTen: Codable {
        var id: Int
        var question: String
        var answer: String
        var author: User10?
        var attachment: Attachment?
        var favourite: Bool?
        var tips: [String]?
    }
    struct User10: Codable {
        var isAdmin: Bool?
        var username: String
    }
    
}

