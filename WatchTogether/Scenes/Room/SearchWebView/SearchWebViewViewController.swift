//
//  SearchWebViewViewController.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import UIKit
import WebKit

protocol SearchWebViewViewControllerDelegate: class {
    func searchWebViewViewControllerDidSelectVideo(_ controller: SearchWebViewViewController?, id: String)
}
class SearchWebViewViewController: WTViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
            webView.addObserver(self, forKeyPath: "URL", options: [.new, .old], context: nil)

        }
    }
    
    weak var delegate: SearchWebViewViewControllerDelegate?
    
    override func setup() {
        super.setup()
        
        let url = URL(string: "https://www.youtube.com/")!
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("emintest:newkey : ", change?[.newKey])

        if let urlString = (change?[.newKey] as? URL)?.description,
           urlString.contains("watch?v=") {
            
            let components = urlString.components(separatedBy: "watch?v=")
            let lastComponent = components.last
            let videoId = lastComponent?.split(separator: "&").first
            self.delegate?.searchWebViewViewControllerDidSelectVideo(self, id: (String(videoId ?? "")))
        }
    }
    
    @IBAction func backPageButtonTapAction(_ sender: Any) {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }
    
    
}

extension SearchWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            print("link")
            decisionHandler(.cancel)
            return
        }
        print("no link")
        decisionHandler(.allow)
    }
}
