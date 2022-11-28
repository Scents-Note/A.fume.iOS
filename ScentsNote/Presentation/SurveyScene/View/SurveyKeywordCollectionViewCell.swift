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
  
  var clickKeyword: (() -> Void)?
  
  static let identifier = "SurveyKeywordCollectionViewCell"
  static let height: CGFloat = 42
  let disposeBag = DisposeBag()
  
  private let keywordLabel = UILabel().then {
    $0.font = .notoSans(type: .regular, size: 15)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
    self.bindUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
    self.bindUI()
  }
   
  func configureUI(){
    self.contentView.addSubview(self.keywordLabel)
    self.keywordLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(18)
    }
  }
    
  func updateUI(keyword: SurveyKeyword?) {
    guard let keyword = keyword else { return }
    self.keywordLabel.text = "#"+keyword.name
    if keyword.isLiked == true {
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
  
  func updateUI(ingredient: FilterIngredient) {
//    guard let keyword = keyword else { return }
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
  
  
  
  func bindUI() {
    self.rx.tapGesture()
      .when(.recognized)
      .subscribe(onNext: { [weak self] _ in
        self?.clickKeyword?()
      })
      .disposed(by: disposeBag)
    
  }
}
