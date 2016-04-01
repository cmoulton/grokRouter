//
//  PostRouter.swift
//  grokRouter
//
//  Created by Christina Moulton on 2016-04-01.
//  Copyright © 2016 Teak Mobile Inc. All rights reserved.
//

import Foundation
import Alamofire

enum PostRouter: URLRequestConvertible {
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
      
      var URL = NSURL(string: PostRouter.baseURLString)!
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