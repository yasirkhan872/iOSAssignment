//
//  NewsDetailViewController.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    var urlString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create WKWebView
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)

        // Add activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        // Load webpage
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        print("Webpage loading failed: \(error.localizedDescription)")
    }
}
