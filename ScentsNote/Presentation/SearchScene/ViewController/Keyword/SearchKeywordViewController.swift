//
//  SearchKeywordViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import FirebaseAnalytics

final class SearchKeywordViewController: UIViewController {
  
  // MARK: - Vars & Lets
  var viewModel: SearchKeywordViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.text = "무엇을 찾으시나요?"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .bold, size: 22)
  }
  
  private let searchButton = UIButton().then {
    $0.setImage(.btnSearch, for: .normal)
    $0.tintColor = .blackText
  }
  private let keywordTextField = InputField().then { $0.setPlaceholder(string: "브랜드 혹은 제품명을 검색해주세요.") }
  private lazy var keywordSection = InputSection(title: "", textField: self.keywordTextField, button: self.searchButton)

  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
    self.configureDelegate()
    Analytics.logEvent(GoogleAnalytics.Screen.searchWindow, parameters: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    self.hidesBottomBarWhenPushed = false
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.configureNavigation()
    
    self.view.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.view.addSubview(self.keywordSection)
    self.keywordSection.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
      $0.left.right.equalToSuperview().inset(16)
    }
  }
  
  func configureNavigation() {
    self.view.backgroundColor = .white
    self.setBackButton()
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.keywordTextField.rx.text.orEmpty
      .bind(to: input.keywordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
//    self.searchButton.rx.tap
//      .bind(to: input.searchButtonDidTapEvent)
//      .disposed(by: self.disposeBag)
      
      self.searchButton.rx.tap
          .subscribe(onNext: { [weak self] _ in
              if self?.keywordTextField.text == "" {
                  self?.view.makeToast("검색어를 입력해주세요.")
              } else {
                  input.searchButtonDidTapEvent.accept(())
              }
          }).disposed(by: disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    
    output.finish
      .asDriver()
      .skip(1)
      .drive(onNext: { [weak self] _ in
        self?.popViewController(from: .search)
      })
      .disposed(by: self.disposeBag)
  }
    
    private func configureDelegate() {
       self.keywordTextField.delegate = self
    }
    
    private func popViewController(from: CoordinatorType) {
        self.navigationController?.hidesBottomBarWhenPushed = false
        DispatchQueue.main.async {
      if let idx = self.navigationController?.viewControllers.firstIndex(where: { $0 === self }) {
        self.navigationController?.viewControllers.remove(at: idx)
      }
    }
  }
}

extension SearchKeywordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if keywordTextField.text == "" {
            self.view.makeToast("검색어를 입력해주세요.")
        } else {
            self.viewModel.input.searchButtonDidTapEvent.accept(())
        }
        return true
    }
}
