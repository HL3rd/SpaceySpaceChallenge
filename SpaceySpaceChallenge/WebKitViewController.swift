//
//  WebKitViewController.swift
//  SpaceySpaceChallenge
//
//  Created by Horacio Lopez on 2/17/22.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {

    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        title = "Loading..."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        view.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        view.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        return view
    }()
    
    lazy var refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonItemTapped))
    
    @objc func refreshButtonItemTapped() {
        self.webView.reload()
    }
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        return progressView
    }()
    
    var keepNavBar = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setLayout()
    }
    
    func setLayout() {
        view.addSubview(progressView)
        view.addSubview(webView)

        let navBarFrame = self.navigationController?.navigationBar.frame
        let viewFrame = view.bounds
        let finalHeight = viewFrame.height - (navBarFrame?.height ?? 0)
        
        let finalFrame = CGRect(x: 0, y: navBarFrame?.maxY ?? 0, width: viewFrame.width, height: finalHeight)
        
        view.backgroundColor = .white
        progressView.frame = finalFrame
        webView.frame = finalFrame
    }
    
    fileprivate func setupNavigation() {
        navigationItem.setRightBarButton(refreshBarButtonItem, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = !(keepNavBar)
    }
}

extension WebKitViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
