//
//  RecommandPerfumeCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit
import SnapKit
import Then

final class HomeRecommendationCell: UICollectionViewCell {
  
  static let width: CGFloat = UIScreen.main.bounds.width - 120
  static let height: CGFloat = 297
  
  var keywords = [String]()
  
  private let bgView = UIView().then {
    $0.backgroundColor = .lightGray
  }
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  private let brandLabel = UILabel().then {
    $0.textColor = .grayCd
    $0.font = .notoSans(type: .regular, size: 14)
  }
  private let nameLabel = UILabel().then {
    $0.textColor = .black1d
    $0.font = .notoSans(type: .bold, size: 16)
  }

  private let perfumeRecommandKeyword = HomeRecommendationKeywordView()

  required init?(coder: NSCoder) {
    fatalError()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
    
//    self.backgroundColor = .black
    
    
  }
  
  private func configureUI() {
    self.perfumeRecommandKeyword.dataSource = self
    self.perfumeRecommandKeyword.isScrollEnabled = false
    
    
//    self.bgView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(self.bgView)
    self.bgView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(86)
      $0.bottom.left.right.equalToSuperview()
    }
    
    self.contentView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.width.height.equalTo(172)
      $0.centerX.equalToSuperview()
    }

    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.top.equalTo(self.imageView.snp.bottom).offset(20)
      $0.left.equalToSuperview().offset(20)
    }

    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom).offset(3)
//      $0.bottom.equalToSuperview().offset(59)
      $0.left.equalToSuperview().offset(20)
      $0.right.equalToSuperview().offset(-20)
    }
    
    self.contentView.addSubview(self.perfumeRecommandKeyword)
    self.perfumeRecommandKeyword.snp.makeConstraints {
      $0.top.equalTo(self.nameLabel.snp.bottom).offset(15)
      $0.left.equalToSuperview().offset(20)
      $0.right.equalToSuperview().offset(-20)
      $0.height.equalTo(26)
    }
  }
  
  
  
  func updateUI(perfume: Perfume?) {
    guard let perfume = perfume else { return }
    self.imageView.load(url: perfume.imageUrl)
    self.brandLabel.text = perfume.brandName
    self.nameLabel.text = perfume.name
    self.keywords = perfume.keywordList ?? []
    self.perfumeRecommandKeyword.reloadData()
  }
  
  
}

extension HomeRecommendationCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.keywords.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecommendationKeywordCell", for: indexPath) as! HomeRecommendationKeywordCell
    cell.updateUI(name: self.keywords[indexPath.row])
    return cell
  }
}
