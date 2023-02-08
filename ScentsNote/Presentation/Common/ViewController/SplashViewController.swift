//
//  SplashViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SplashViewController: UIViewController {
  
  // MARK: - UI
  private let textLogoImageView = UIImageView().then {
    $0.image = .textLogo
    $0.contentMode = .scaleAspectFit
  }
  private let bottomLogoImageView = UIImageView().then {
    $0.image = .logo
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - Vars & Lets
  var viewModel: SplashViewModel!
  private let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.checkVersion()
  }
  
  private func configureUI() {
    self.view.backgroundColor = .blackText
    self.view.addSubview(self.textLogoImageView)
    self.textLogoImageView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(274)
      $0.left.equalToSuperview().offset(24)
    }
    
    self.view.addSubview(self.bottomLogoImageView)
    self.bottomLogoImageView.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-22)
      $0.centerX.equalToSuperview()
    }
  }
  
  private func checkVersion() {
    self.viewModel.checkVersion()
  }
}
