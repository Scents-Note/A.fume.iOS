//
//  WebViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import UIKit
import WebKit
import SnapKit


final class WebViewController: UIViewController {
  
  let webView = WKWebView()
  var urlString: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    self.configureDelegate()

  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.loadUrl()
  }
  
  private func configureUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(self.webView)
    self.webView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  private func configureDelegate() {
    self.webView.uiDelegate = self
    self.webView.navigationDelegate = self
  }
  
  func loadUrl() {
    guard let urlString = self.urlString, let url = URL(string: urlString) else { return }
    self.webView.load(URLRequest(url: url))
  }
}

extension WebViewController: WKUIDelegate {
  func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    if navigationAction.targetFrame == nil {
      self.webView.load(navigationAction.request)
    }
    return nil
  }
}

/// 중복 reload 방지
extension WebViewController: WKNavigationDelegate {
  func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    self.webView.reload()
  }
}
