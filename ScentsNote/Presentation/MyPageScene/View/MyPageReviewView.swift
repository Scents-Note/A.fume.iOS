//
//  MyPageReviewView.swift
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

final class MyPageReviewView: UIView {
  
  // MARK: - UI
  private let emptyView = UIView()
  private let emptyImage = UIImageView().then {
    $0.image = .emptyMypageReview
  }
  private let emptyLabel = UILabel().then {
    $0.textAlignment = .center
    $0.text = "아직 시향 노트가 비어 있어요.\n그동안 사용했던 향수\n혹은 시향해봤던 향수를\n기록해보세요."
    $0.numberOfLines = 4
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
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewGroupInMyPageLayout).then {
    $0.register(MyPageReviewGroupCell.self)
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
  func bindViewModel() {
    let input = self.viewModel.scrollInput
    self.loginButton.rx.tap.asObservable()
      .subscribe(onNext: {
        input.loginButtonDidTapEvent.accept(())
      })
      .disposed(by: self.disposeBag)
    
    let output = self.viewModel.output

    output.loginState
      .asDriver()
      .drive(onNext: { [weak self] isLoggedIn in
        self?.collectionView.isHidden = !isLoggedIn
        self?.emptyView.isHidden = !isLoggedIn
        self?.loginView.isHidden = isLoggedIn
      })
      .disposed(by: self.disposeBag)

    output.reviews
      .subscribe(onNext: { [weak self] reviews in
        self?.emptyView.isHidden = !reviews.isEmpty
      })
      .disposed(by: self.disposeBag)
    
    output.reviews
      .bind(to: self.collectionView.rx.items(cellIdentifier: "MyPageReviewGroupCell", cellType: MyPageReviewGroupCell.self)) { _, reviews, cell in
        cell.updateUI(reviews: reviews)
        cell.onClickReview = { [weak self] reviewIdx in
          self?.viewModel.scrollInput.reviewCellDidTapEvent.accept(reviewIdx)
        }
      }
      .disposed(by: self.disposeBag)
    
//    output.reviews
//      .bind(to: self.collectionView.rx.items) { cv, row, item in
//        if row == 0 {
//          let cell = cv.dequeueReusableCell(withReuseIdentifier: "MyPageReviewHeaderCell", for: IndexPath.init(row: row, section: 0)) as! MyPageReviewHeaderCell
//          return cell
//        } else {
//          let cell = cv.dequeueReusableCell(withReuseIdentifier: "MyPageReviewGroupCell", for: IndexPath.init(row: row, section: 0)) as! MyPageReviewGroupCell
//          cell.updateUI(reviews: item)
//          cell.onClickReview = { [weak self] reviewIdx in
//            self?.viewModel.scrollInput.reviewCellDidTapEvent.accept(reviewIdx)
//          }
//          return cell
//        }
//      }
//      .disposed(by: self.disposeBag)
//
  }
}
