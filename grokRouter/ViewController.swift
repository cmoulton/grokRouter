//
//  ViewController.swift
//  grokRouter
//
//  Created by Christina Moulton on 2015-10-19.
//  Copyright © 2015 Teak Mobile Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
  enum Router: URLRequestConvertible {
    static let baseURLString = "http://jsonplaceholder.typicode.com/"
    
    case Get(Int)
    case Create([String: AnyObject])
    case Delete(Int)
    
    var URLRequest: NSMutableURLRequest {
      var method: Alamofire.Method {
        switch self {
        case .Get:
          return .GET
        case .Create:
          return .POST
        case .Delete:
          return .DELETE
        }
      }
      
      let result: (path: String, parameters: [String: AnyObject]?) = {
        switch self {
          case .Get(let postNumber):
            return ("posts/\(postNumber)", nil)
          case .Create(let newPost):
            return ("posts", newPost)
          case .Delete(let postNumber):
            return ("posts/\(postNumber)", nil)
        }
      }()
      
      let URL = NSURL(string: Router.baseURLString)!
      let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
      
      let encoding = Alamofire.ParameterEncoding.URL
      let (encoded, _) = encoding.encode(URLRequest, parameters: result.parameters)
      
      encoded.HTTPMethod = method.rawValue
      
      return encoded
    }
  }
  
  func getFirstPost() {
    // Get first post
    let request = Alamofire.request(Router.Get(1))
      .responseJSON { response in
        guard response.result.error == nil else {
          // got an error in getting the data, need to handle it
          print("error calling GET on /posts/1")
          print(response.result.error!)
          return
        }
        
        if let value: AnyObject = response.result.value {
          // handle the results as JSON, without a bunch of nested if loops
          let post = JSON(value)
          // now we have the results, let's just print them though a tableview would definitely be better UI:
          print("The post is: " + post.description)
          if let title = post["title"].string {
            // to access a field:
            print("The title is: " + title)
          } else {
            print("error parsing /posts/1")
          }
        }
    }
    debugPrint(request)
  }
  
  func createPost() {
    let newPost = ["title": "Frist Psot", "body": "I iz fisrt", "userId": 1]
    Alamofire.request(Router.Create(newPost))
      .responseJSON { response in
        guard response.result.error == nil else {
          // got an error in getting the data, need to handle it
          print("error calling GET on /posts/1")
          print(response.result.error!)
          return
        }
        
        if let value: AnyObject = response.result.value {
          // handle the results as JSON, without a bunch of nested if loops
          let post = JSON(value)
          print("The post is: " + post.description)
        }
    }
  }
  
  func deleteFirstPost() {
    Alamofire.request(Router.Delete(1))
      .responseJSON { response in
        if let error = response.result.error {
          // got an error while deleting, need to handle it
          print("error calling DELETE on /posts/1")
          print(error)
        }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    getFirstPost()
    
    //createPost()
    
    //deleteFirstPost()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

