//
//  PerfumeDetailImageCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import SnapKit
import Then
import Cosmos
import Kingfisher
import RxSwift
import RxGesture
import RxRelay

final class PerfumeDetailTitleCell: UICollectionViewCell {
 
    var clickCompareViewSubject = PublishRelay<Void>()
    
  // MARK: - UI
  private let mainImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let brandLabel = UILabel().then {
    $0.textColor = .gray125
    $0.font = .nanumMyeongjo(type: .regular, size: 16)
  }
  private let nameLabel = UILabel().then {
    $0.textColor = .black1d
    $0.font = .notoSans(type: .bold, size: 24)
  }
  
  private let starView = CosmosView().then {
    $0.settings.starSize = 16
    $0.settings.fillMode = .half
    $0.settings.emptyImage = .starUnfilled
    $0.settings.filledImage = .starFilled
    $0.settings.starMargin = 4
  }
  
  private let scoreLabel = UILabel().then {
    $0.textColor = .perfumeDetailScore
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
  }
  
  private lazy var scoreStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.addArrangedSubview(self.starView)
    $0.addArrangedSubview(self.scoreLabel)
    $0.spacing = 8
  }
    
    private let compareLabel = UILabel().then {
        $0.text = "가격 비교하기"
        $0.textColor = #colorLiteral(red: 0.07058823854, green: 0.07058823854, blue: 0.07058823854, alpha: 1)
        $0.font = .notoSans(type: .regular, size: 14.0)
    }
    
    private let arrowRightView = UIImageView().then {
      $0.image = .arrowRightCenter
    }
    
    private lazy var compareStackView = UIStackView().then {
      $0.axis = .horizontal
      $0.spacing = 2
    }
    
    private let comparePriceView = UIView().then {
        $0.layer.borderColor = UIColor.gray125.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 2.0
    }
    
    var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
      self.bindRx()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configureUI(){
    self.contentView.addSubview(self.mainImageView)
    self.mainImageView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.width)
    }
    
    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.top.equalTo(self.mainImageView.snp.bottom).offset(33)
      $0.left.right.equalToSuperview().inset(16)
    }
    
    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom).offset(8)
      $0.left.right.equalToSuperview().inset(16)
    }
    
    self.contentView.addSubview(self.scoreStackView)
    self.scoreStackView.snp.makeConstraints {
      $0.top.equalTo(self.nameLabel.snp.bottom).offset(10.5)
      $0.left.equalToSuperview().offset(20)
    }
      
      self.contentView.addSubview(self.comparePriceView)
      self.comparePriceView.snp.makeConstraints {
          $0.top.equalTo(self.scoreStackView.snp.bottom).offset(26)
          $0.leading.equalToSuperview().offset(16)
          $0.trailing.equalToSuperview().inset(16)
          $0.height.equalTo(42)
      }
      
      self.comparePriceView.addSubview(compareStackView)
      compareStackView.addArrangedSubview(self.compareLabel)
      compareStackView.addArrangedSubview(self.arrowRightView)
      compareStackView.snp.makeConstraints {
          $0.center.equalToSuperview()
          self.arrowRightView.snp.makeConstraints {
              $0.size.equalTo(16)
          }
      }

  }
  
  func updateUI(perfumeDetail: PerfumeDetail) {
    self.mainImageView.kf.setImage(with: URL(string: perfumeDetail.imageUrls[0]))
    self.brandLabel.text = perfumeDetail.brandName
    self.nameLabel.text = perfumeDetail.name
    self.starView.rating = perfumeDetail.score
    self.scoreLabel.text = "\(perfumeDetail.score)"
    self.comparePriceView.isUserInteractionEnabled = perfumeDetail.priceComparisonUrl == "" ? false : true
  }
    
    func bindRx() {
        self.comparePriceView.rx.tapGesture()
            .subscribe(onNext: { [weak self] _ in
                self?.clickCompareViewSubject.accept(())
            }).disposed(by: disposeBag)
    }
}
