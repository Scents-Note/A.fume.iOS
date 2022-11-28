//
//  FilterBrandInitialCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import UIKit
import RxSwift
import RxRelay
import RxGesture
import SnapKit
import Then

final class FilterBrandInitialCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()
  
  private let initialLabel = UILabel()
  
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
    self.contentView.translatesAutoresizingMaskIntoConstraints = false
    
    self.contentView.addSubview(self.initialLabel)
    self.initialLabel.translatesAutoresizingMaskIntoConstraints = false
    self.initialLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
//  
//  func updateUI(ingredient: FilterIngredient) {
//    self.keywordLabel.text = "#"+ingredient.name
//    if ingredient.isSelected == true {
//      self.containerView.backgroundColor = .bgSurveySelected
//      self.keywordLabel.textColor = .white
//      self.containerView.layer.borderWidth = 0
//    } else {
//      self.containerView.backgroundColor = .white
//      self.keywordLabel.textColor = .grayCd
//      self.containerView.layer.borderWidth = 1
//      self.containerView.layer.borderColor = UIColor.grayCd.cgColor
//    }
//  }
//  
  func clickSeries() -> Observable<UITapGestureRecognizer> {
    self.rx.tapGesture().when(.recognized).asObservable()
  }
}
