//
//  PerfumeDetailImageCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import SnapKit
import Then

final class PerfumeDetailTitleCell: UICollectionViewCell {
 
  private let mainImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let brandLabel = UILabel()
  private let nameLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
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
      $0.top.equalTo(self.mainImageView.snp.bottom)
      $0.left.right.equalToSuperview()
    }
    
    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom)
      $0.left.right.equalToSuperview()
    }
  }
  
  func updateUI(perfumeDetail: PerfumeDetail) {
    self.mainImageView.load(url: perfumeDetail.imageUrls[0])
    self.brandLabel.text = perfumeDetail.brandName
    self.nameLabel.text = perfumeDetail.name
  }
}
