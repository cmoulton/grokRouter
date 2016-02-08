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
      
      let url:NSURL = {
        // build up and return the URL for each endpoint
        let relativePath:String?
        switch self {
          case .Get(let postNumber):
            relativePath = "posts/\(postNumber)"
          case .Create:
            relativePath = "posts"
          case .Delete(let postNumber):
            relativePath = "posts/\(postNumber)"
        }
        
        var URL = NSURL(string: Router.baseURLString)!
        if let relativePath = relativePath {
          URL = URL.URLByAppendingPathComponent(relativePath)
        }
        return URL
      }()
      
      let params: ([String: AnyObject]?) = {
        switch self {
        case .Get, .Delete:
          return (nil)
        case .Create(let newPost):
          return (newPost)
        }
      }()
      
      let URLRequest = NSMutableURLRequest(URL: url)
      
      let encoding = Alamofire.ParameterEncoding.JSON
      let (encodedRequest, _) = encoding.encode(URLRequest, parameters: params)
      
      encodedRequest.HTTPMethod = method.rawValue
      
      return encodedRequest
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

