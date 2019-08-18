//
//  AuthViewController.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 06/08/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import UIKit
import WebKit

struct AuthInfo: Decodable
{
    let access_token: String
    let scope: String
    let token_type: String
}

protocol TokenKeeper {
    func updateToken(_ token: String)
}

class AuthViewController: UIViewController {
    private let scheme = "gists" // схема для callback
    private let client_id = "12df71788e351a97912a"
    private let client_secret = "b58135b809479746962104ccdd1db63ec4fbfee0"
    

   
    var delegate: TokenKeeper?
    
  
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.dismiss(animated: false, completion: nil)
        var urlc = URLComponents(string: "https://github.com/login/oauth/authorize")
        
        urlc?.queryItems = [URLQueryItem(name: "client_id", value: client_id),
                            URLQueryItem(name: "scope", value: "gist")]
        webView.navigationDelegate = self
        webView.load(URLRequest(url: urlc!.url!))
    }
    
    
}
extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        defer {
            decisionHandler(.allow)
        }
        
        if let url = navigationAction.request.url, url.scheme == scheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            if let temp_code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                
                var urlc = URLComponents(string: "https://github.com/login/oauth/access_token")
                
                urlc?.queryItems = [URLQueryItem(name: "client_id", value: client_id),
                                    URLQueryItem(name: "client_secret", value: client_secret),
                                    URLQueryItem(name: "code", value: temp_code)
                ]
                
                
                var request = URLRequest(url: urlc!.url!)
                request.addValue( "application/json", forHTTPHeaderField: "Accept")
                
                let task = URLSession.shared.dataTask(with: request){ data,response, error in
                    let authInfo = try? JSONDecoder().decode(AuthInfo.self, from: data!)
                    
//                    if let token = authInfo?.access_token{
//                        self.delegate?.updateToken(token)
//                    }
//                    
                    DispatchQueue.main.async{
                        if let token = authInfo?.access_token{
                            self.delegate?.updateToken(token)
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                task.resume()
            }
            
        }
        
        
    }
}




