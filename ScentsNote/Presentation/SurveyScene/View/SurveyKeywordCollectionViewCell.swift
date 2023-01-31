//
//  SurveyKeywordCollectionViewCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/03.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class SurveyKeywordCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "SurveyKeywordCollectionViewCell"
  static let height: CGFloat = 42
  static let width: CGFloat = 100
  var disposeBag = DisposeBag()
  
  let keywordLabel = UILabel().then {
    $0.textAlignment = .center
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
    self.disposeBag = DisposeBag()
  }

  func configureUI(){
    self.contentView.addSubview(self.keywordLabel)
    self.keywordLabel.translatesAutoresizingMaskIntoConstraints = false
    self.keywordLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.equalToSuperview().offset(18)
      $0.right.equalToSuperview().offset(-18)
    }
  }
    
  func updateUI(keyword: Keyword?) {
    guard let keyword = keyword else { return }
    self.keywordLabel.text = "#"+keyword.name
    if keyword.isSelected == true {
      self.backgroundColor = .bgSurveySelected
      self.keywordLabel.textColor = .white
      self.layer.borderWidth = 0
    } else {
      self.backgroundColor = .white
      self.keywordLabel.textColor = .grayCd
      self.layer.borderWidth = 1
      self.layer.borderColor = UIColor.grayCd.cgColor
    }
    self.keywordLabel.layoutIfNeeded()
  }
  
  func updateUI(ingredient: FilterIngredient) {
    self.keywordLabel.text = "#"+ingredient.name
    if ingredient.isSelected == true {
      self.backgroundColor = .bgSurveySelected
      self.keywordLabel.textColor = .white
      self.layer.borderWidth = 0
    } else {
      self.backgroundColor = .white
      self.keywordLabel.textColor = .grayCd
      self.layer.borderWidth = 1
      self.layer.borderColor = UIColor.grayCd.cgColor
    }
  }
  
  func clickKeyword() -> Observable<UITapGestureRecognizer> {
    self.rx.tapGesture().when(.recognized).asObservable()
  }
}
