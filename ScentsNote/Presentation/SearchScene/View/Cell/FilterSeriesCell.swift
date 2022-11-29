//
//  FilterSeriesCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import UIKit
import RxSwift
import RxRelay
import RxGesture
import SnapKit
import Then

final class FilterSeriesCell: UICollectionViewCell {
  
  static let height: CGFloat = 42
  var disposeBag = DisposeBag()
  
  private let containerView = UIView()
  private let keywordLabel = UILabel().then {
    $0.font = .notoSans(type: .regular, size: 15)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.disposeBag = DisposeBag()
  }
  
  func configureUI(){
    contentView.translatesAutoresizingMaskIntoConstraints = false
    self.containerView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(self.containerView)
    self.containerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(42)
    }
    
    self.keywordLabel.translatesAutoresizingMaskIntoConstraints = false
    self.containerView.addSubview(self.keywordLabel)
    self.keywordLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(18)
    }
  }
  
  func updateUI(ingredient: FilterIngredient) {
    self.keywordLabel.text = "#"+ingredient.name
    if ingredient.isSelected == true {
      self.containerView.backgroundColor = .bgSurveySelected
      self.keywordLabel.textColor = .white
      self.containerView.layer.borderWidth = 0
    } else {
      self.containerView.backgroundColor = .white
      self.keywordLabel.textColor = .grayCd
      self.containerView.layer.borderWidth = 1
      self.containerView.layer.borderColor = UIColor.grayCd.cgColor
    }
  }
  
  func clickSeries() -> Observable<UITapGestureRecognizer> {
    self.rx.tapGesture().when(.recognized).asObservable()
  }
}
