//
//  PerfumeComparePriceViewController.swift
//  ScentsNote
//
//  Created by Soo on 2/4/24.
//

import Foundation
import UIKit
import WebKit
import RxSwift

class PerfumeComparePriceViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var disposeBag = DisposeBag()
    
    private let navigationView = UIView().then { $0.backgroundColor = .white }
    private let titleLabel = UILabel().then {
      $0.text = "필터"
      $0.textColor = .blackText
      $0.font = .nanumMyeongjo(type: .extraBold, size: 22)
    }
    
    private let closeButton = UIButton().then { $0.setImage(.btnClose, for: .normal) }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        configureUI()
        bindRx()
    }
    
    private func configureWebView() {
        // WKWebView 초기화
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self

        // 네이버 웹 페이지 로드
        if let url = URL(string: "https://www.naver.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.navigationView)
        self.navigationView.snp.makeConstraints {
          $0.top.equalTo(self.view.safeAreaLayoutGuide)
          $0.left.right.equalToSuperview()
          $0.height.equalTo(56)
        }
        
        self.navigationView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
          $0.centerY.equalToSuperview()
          $0.left.equalToSuperview().offset(16)
        }
        
        self.navigationView.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
          $0.centerY.equalToSuperview()
          $0.right.equalToSuperview().offset(-16)
        }
        
        self.view.addSubview(webView)
        self.webView.snp.makeConstraints {
            $0.top.equalTo(self.navigationView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // WKNavigationDelegate 메서드 (선택 사항)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("로딩 완료")
    }
    
    func bindRx() {
        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
