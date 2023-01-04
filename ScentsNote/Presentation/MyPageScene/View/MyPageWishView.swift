//
//  MyPageWishView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxDataSources

final class MyPageWishView: UIView {
  
  // MARK: - UI
  private let emptyView = UIView()
  private let emptyImage = UIImageView().then {
    $0.image = .favoriteInactive
  }
  private let emptyLabel = UILabel().then {
    $0.textAlignment = .center
    $0.text = "아직 시향해보고 싶은 향수가 없군요!\n평소에 관심 있었던 향수를\n위시리스트에 추가해보세요!"
    $0.numberOfLines = 3
    $0.textColor = .grayCd
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }
  
  private let loginView = UIView()
  private let loginLabel = UILabel().then {
    $0.textAlignment = .center
    $0.text = "로그인 후 사용 가능합니다.\n로그인을 해주세요."
    $0.numberOfLines = 2
    $0.textColor = .grayCd
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }

  private let loginButton = UIButton().then {
    $0.setTitle("로그인 하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    $0.backgroundColor = .blackText
  }
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.wishLayout).then {
    $0.register(MyPageWishCell.self)
  }
  
  // MARK: - Vars & Lets
  var viewModel: MyPageViewModel
  let disposeBag = DisposeBag()
  
  
  // MARK: - Life Cycle
  init(viewModel: MyPageViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    self.configureUI()
    self.bindViewModel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.addSubview(self.emptyView)
    self.emptyView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    self.emptyView.addSubview(self.emptyImage)
    self.emptyImage.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.size.equalTo(44)
    }
    
    self.emptyView.addSubview(self.emptyLabel)
    self.emptyLabel.snp.makeConstraints {
      $0.top.equalTo(self.emptyImage.snp.bottom).offset(12)
      $0.bottom.left.right.equalToSuperview()
    }
    
    self.addSubview(self.loginView)
    self.loginView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.right.equalToSuperview()
    }
    
    self.loginView.addSubview(self.loginLabel)
    self.loginLabel.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }
    
    self.loginView.addSubview(self.loginButton)
    self.loginButton.snp.makeConstraints {
      $0.top.equalTo(self.loginLabel.snp.bottom).offset(16)
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(52)
    }
  }
  
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    let input = self.viewModel.scrollInput
    self.loginButton.rx.tap.asObservable()
      .subscribe(onNext: {
        input.loginButtonDidTapEvent.accept(())
      })
      .disposed(by: self.disposeBag)
    
    let output = self.viewModel.output
    self.bindPerfumes(output: output)
    
  }
  
  private func bindPerfumes(output: MyPageViewModel.Output) {
    output.loginState
      .asDriver()
      .drive(onNext: { [weak self] isLoggedIn in
        self?.collectionView.isHidden = !isLoggedIn
        self?.emptyView.isHidden = !isLoggedIn
        self?.loginView.isHidden = isLoggedIn
      })
      .disposed(by: self.disposeBag)
    
    output.perfumes
      .subscribe(onNext: { [weak self] perfumes in
        self?.emptyView.isHidden = !perfumes.isEmpty
      })
      .disposed(by: self.disposeBag)
    
    output.perfumes
      .bind(to: self.collectionView.rx.items(cellIdentifier: "MyPageWishCell", cellType: MyPageWishCell.self)) { index, perfume, cell in
        cell.updateUI(perfume: perfume)
        cell.clickPerfume()
          .subscribe(onNext: { [weak self] _ in
            self?.viewModel.scrollInput.perfumeCellDidTapEvent.accept(perfume.idx)
          })
          .disposed(by: cell.disposeBag)
      }
      .disposed(by: self.disposeBag)
  }
}
