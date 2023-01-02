//
//  ReviewCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/29.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then
import Cosmos

final class ReviewCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  var disposeBag = DisposeBag()
  
  // MARK: - UI
  private let reportLabel = UILabel().then {
    $0.textAlignment = .center
    $0.text = "신고로 인해 가려진 시향노트 입니다."
    $0.textColor = .lightGray185
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }
  
  private let containerView = UIView()
  
  private let likeCountLabel = UILabel().then {
    $0.textColor = .grayCd
    $0.font = .systemFont(ofSize: 12, weight: .regular)
  }
  
  private let dividerView = UIView().then {
    $0.backgroundColor = .grayCd
  }
  
  private lazy var rightTopStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.addArrangedSubview(self.heartButton)
    $0.addArrangedSubview(self.likeCountLabel)
    $0.addArrangedSubview(self.dividerView)
    $0.addArrangedSubview(self.reportButton)
    
    $0.setCustomSpacing(4, after: self.heartButton)
    $0.setCustomSpacing(7.5, after: self.likeCountLabel)
    $0.setCustomSpacing(7.5, after: self.dividerView)
  }
  
  private let reportButton = UIButton().then {
    $0.setTitle("신고", for: .normal)
    $0.setTitleColor(.grayCd, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .regular, size: 12)
  }
  
  private let ageAndGenderLabel = UILabel().then {
    $0.textColor = .darkGray7d
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }
  
  private let contentLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .systemFont(ofSize: 16, weight: .regular)
    $0.numberOfLines = 0
  }
  
  private let starView = CosmosView().then {
    $0.settings.starSize = 12
    $0.settings.fillMode = .half
    $0.settings.emptyImage = .starUnfilled
    $0.settings.filledImage = .starFilled
    $0.settings.starMargin = 2
  }
 
  private let scoreLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 12)
  }
  
  private let nicknameLabel = UILabel().then {
    $0.textColor = .darkGray7d
    $0.font = .nanumMyeongjo(type: .regular, size: 12)
  }
  
  private let quotesImageView = UIImageView().then {
    $0.image = .quotes
  }
  
  private let heartButton = UIButton()
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    self.disposeBag = DisposeBag()
  }
   
  // MARK: Configure
  func configureUI(){
    self.contentView.layer.borderWidth = 1
    self.contentView.layer.borderColor = UIColor.grayCd.cgColor
    
    self.contentView.addSubview(self.reportLabel)
    self.reportLabel.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(16)
    }
    
    self.contentView.addSubview(self.containerView)
    self.containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    self.containerView.addSubview(self.quotesImageView)
    self.quotesImageView.snp.makeConstraints {
      $0.top.left.equalToSuperview().offset(16)
      $0.width.height.equalTo(14)
    }
    
    self.containerView.addSubview(self.heartButton)
    self.heartButton.snp.makeConstraints {
      $0.width.height.equalTo(16)
    }
    
    self.containerView.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.width.equalTo(1)
      $0.height.equalTo(11)
    }
    
    self.containerView.addSubview(self.rightTopStackView)
    self.rightTopStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.right.equalToSuperview().offset(-16)
      $0.height.equalTo(16)
    }
    
    self.containerView.addSubview(self.ageAndGenderLabel)
    self.ageAndGenderLabel.snp.makeConstraints {
      $0.top.equalTo(self.quotesImageView.snp.bottom).offset(12)
      $0.left.equalTo(self.quotesImageView)
    }
    
    self.containerView.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.equalTo(self.ageAndGenderLabel.snp.bottom).offset(12)
      $0.left.equalTo(self.quotesImageView)
    }
    
    self.containerView.addSubview(self.starView)
    self.starView.snp.makeConstraints {
      $0.top.equalTo(self.contentLabel.snp.bottom).offset(18)
      $0.bottom.equalToSuperview().offset(-18)
      $0.left.equalTo(self.quotesImageView)
    }
    
    self.containerView.addSubview(self.scoreLabel)
    self.scoreLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.starView)
      $0.left.equalTo(self.starView.snp.right).offset(6)
    }
    
    self.containerView.addSubview(self.nicknameLabel)
    self.nicknameLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.starView)
      $0.right.equalToSuperview().offset(-16)
    }
  }
    
  func updateUI(review: ReviewInPerfumeDetail) {
    guard !review.isReported else {
      self.containerView.isHidden = true
      self.containerView.snp.makeConstraints {
        $0.height.equalTo(50)
      }
      self.reportLabel.isHidden = false
      return
    }
    self.containerView.isHidden = true
    self.reportLabel.isHidden = true
    self.heartButton.setImage(review.isLiked ? .favoriteActive : .favoriteInactive, for: .normal)
    self.likeCountLabel.text = "\(review.likeCount)"
    let gender = review.gender == 1 ? "남" : "여"
    self.ageAndGenderLabel.text = "\(review.age) / \(gender)"
    self.contentLabel.text = review.content
    self.starView.rating = review.score
    self.scoreLabel.text = "\(review.score)"
    self.nicknameLabel.text = "by. \(review.nickname)"
    self.reportButton.isHidden = review.access != true
  }
  
  func clickHeart() -> Observable<Void> {
    self.heartButton.rx.tap.asObservable()
  }
  
  func clickReport() -> Observable<Void> {
    self.reportButton.rx.tap.asObservable()
  }
}
