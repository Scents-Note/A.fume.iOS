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

final class ReviewCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  var disposeBag = DisposeBag()
  
  // MARK: - UI
  private let likeCountLabel = UILabel().then {
    $0.textColor = .grayCd
    $0.font = .notoSans(type: .regular, size: 12)
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
    $0.textColor = .grayCd
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let contentLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .notoSans(type: .regular, size: 14)
    $0.numberOfLines = 0
  }
 
  private let scoreLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 12)
  }
  
  private let nicknameLabel = UILabel().then {
    $0.textColor = .darkGray7d
    $0.font = .nanumMyeongjo(type: .regular, size: 12)
  }
  
  private let quotesImageView = UIImageView()
  private let heartButton = UIButton()
  private let starLabel = UILabel()
  
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
    
    self.contentView.addSubview(self.quotesImageView)
    self.quotesImageView.snp.makeConstraints {
      $0.top.left.equalToSuperview().offset(16)
      $0.width.height.equalTo(22)
    }
    
    self.contentView.addSubview(self.heartButton)
    self.heartButton.snp.makeConstraints {
      $0.width.height.equalTo(16)
    }
    
    self.contentView.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.width.equalTo(1)
      $0.height.equalTo(11)
    }
    
    self.contentView.addSubview(self.rightTopStackView)
    self.rightTopStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.right.equalToSuperview().offset(-16)
    }
    
    self.contentView.addSubview(self.ageAndGenderLabel)
    self.ageAndGenderLabel.snp.makeConstraints {
      $0.top.equalTo(self.quotesImageView.snp.bottom).offset(10)
      $0.left.equalTo(self.quotesImageView)
    }
    
    self.contentView.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.equalTo(self.ageAndGenderLabel.snp.bottom).offset(4)
      $0.left.equalTo(self.quotesImageView)
    }
    
    self.contentView.addSubview(self.scoreLabel)
    self.scoreLabel.snp.makeConstraints {
      $0.top.equalTo(self.contentLabel.snp.bottom).offset(13)
      $0.left.equalTo(self.quotesImageView)
      $0.bottom.equalToSuperview().offset(-15)
    }
    
    self.contentView.addSubview(self.nicknameLabel)
    self.nicknameLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-16)
      $0.right.equalTo(self.rightTopStackView)
    }
    
//    // TODO: 할 것
//    self.contentView.addSubview(self.starLabel)
//    self.quotesImageView.snp.makeConstraints {
//
//    }
  }
    
  func updateUI(review: ReviewInPerfumeDetail) {
    self.quotesImageView.image = .checkmark
    self.heartButton.setImage(.checkmark, for: .normal)
    self.likeCountLabel.text = "\(review.likeCount)"
    let gender = review.gender == 1 ? "남" : "여"
    self.ageAndGenderLabel.text = "\(review.age) / \(gender)"
    self.contentLabel.text = review.content
    self.scoreLabel.text = "\(review.score)"
    self.nicknameLabel.text = "by. \(review.nickname)"
    self.reportButton.isHidden = review.access != true
  }
  
  func clickReport() -> Observable<Void> {
    self.reportButton.rx.tap.asObservable()
  }
}
