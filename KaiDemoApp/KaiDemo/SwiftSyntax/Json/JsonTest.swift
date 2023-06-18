//
//  JsonTest.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/6/18.
//

import Foundation

struct BlogPost : Decodable {
    enum Category : String, Decodable {
        case swift, combine, debugging, xcode
    }
    
    enum CodingKeys : String, CodingKey {
        case title, category, views, optionalInt
        // 将 "url" 映射为 "htmlLink"
        case htmlLink = "url"
    }
    
    let title: String
//    let url: URL
    let category: Category
    let views: Int
    let optionalInt: Int?
    let htmlLink: URL
}

class JsonTest {
    static func entry() {
        
        print("\n----------   in Swift Json Test    ----------")
        
        let JSON = """
                   {
                       "title": "Optionals in Swift explained: 5 things you should know",
                       "url": "https://www.avanderlee.com/swift/optionals-in-swift-explained-5-things-you-should-know/",
                       "category": "swift",
                       "views": 47093
                   }
                   """
        
        let jsonData = JSON.data(using: .utf8)!
        let blogPost: BlogPost? = try? JSONDecoder().decode(BlogPost.self, from: jsonData)
        
        print("blogPost.title=\(blogPost?.title ?? "<no title>") htmlUrl=\(blogPost?.htmlLink)")
        
        let JSON2 = """
                    [
                        {
                            "title": "Optionals in Swift explained: 5 things you should know",
                            "url": "https://www.avanderlee.com/swift/optionals-in-swift-explained-5-things-you-should-know/",
                            "category": "swift",
                            "views": 47093
                        }
                    ]
                    """
        
        let jsonData2 = JSON2.data(using: .utf8)!
        let blogPosts: [BlogPost]? = try? JSONDecoder().decode([BlogPost].self, from: jsonData2)
        print("blogPosts count = \(blogPosts?.count ?? -1)")
        
        let jsonObj = try! JSONSerialization.jsonObject(with: jsonData, options: [])
        print("jsonObj = \(jsonObj)")
        
        if let dictionary = jsonObj as? [String: Any] {
            if let number = dictionary["views"] as? Int {
                print("jsonObj int = \(number)")
            } else {
                print("jsonObj no int")
            }
            
            for (key, value) in dictionary {
                print("jsonObj key=\(key) value=\(value)")
            }
        } else {
            print("jsonObj is not Dictionary")
        }
    }
}
