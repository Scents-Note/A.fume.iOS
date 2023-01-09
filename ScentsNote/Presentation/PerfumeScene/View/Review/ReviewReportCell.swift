//
//  ReviewReportCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/22.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class ReviewReportCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()

  private let contentLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .notoSans(type: .regular, size: 15)
  }
  
  private let checkView = UIView().then {
    $0.layer.cornerRadius = 9
    $0.layer.borderWidth = 1
  }
  
  private let innerCheckView = UIView().then {
    $0.layer.cornerRadius = 5
  }
  
  private let dividerView = UIView().then {
    $0.backgroundColor = .bgTabBar
  }
  
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
  
  private func configureUI() {
    
    self.contentView.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview()
    }
    
    self.contentView.addSubview(self.checkView)
    self.checkView.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(18)
    }
    
    self.checkView.addSubview(self.innerCheckView)
    self.innerCheckView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.width.height.equalTo(10)
    }
    
    self.contentView.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
    
  func updateUI(report: ReportType.Report) {
    self.contentLabel.text = report.type.description
    self.checkView.layer.borderColor = report.isSelected ? UIColor.pointBeige.cgColor : UIColor.lightGray.cgColor
    self.innerCheckView.backgroundColor = report.isSelected ? .pointBeige : .white
  }
}
