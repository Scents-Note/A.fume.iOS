//
//  PerfumeDetailKeywordsContentView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit
import Then

class PerfumeDetailKeywordsContentView: UIView, UIContentView {
  
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    var keywords: [String] = []
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailKeywordsContentView(self)
    }
  }
  
  private let disposeBag = DisposeBag()
  var keywords = BehaviorRelay<[String]>(value: [])
  
  private let emptyLabel = UILabel().then {
    $0.textAlignment = .center
    $0.numberOfLines = 2
    $0.textColor = .lightGray185
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }
  
  private let collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: .init()).then {
    let layout = LeftAlignedCollectionViewFlowLayout()
    layout.minimumLineSpacing = 12
    layout.minimumInteritemSpacing = 12
    $0.backgroundColor = .white
    $0.isScrollEnabled = false
    $0.isUserInteractionEnabled = false
    $0.collectionViewLayout = layout
    $0.register(PerfumeDetailKeywordCell.self)
  }
  
  
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  override var intrinsicContentSize: CGSize {
    CGSize(width: 0, height: 60)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.invalidateIntrinsicContentSize()
  }
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.addSubview(self.emptyLabel)
    self.emptyLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    self.collectionView.delegate = self
    
    self.bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(configuration: UIContentConfiguration) {
    guard let configuration = configuration as? Configuration else { return }
    let keywords = configuration.keywords
    if keywords.isEmpty {
      self.emptyLabel.text = "향수에 딱 맞는 키워드를\n수집하고 있습니다."
    }
    self.keywords.accept(keywords)
  }
  
  func bindUI() {
    self.keywords
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "PerfumeDetailKeywordCell", cellType: PerfumeDetailKeywordCell.self
      )) { _, keyword, cell in
        cell.updateUI(keyword: keyword)
      }
      .disposed(by: self.disposeBag)
  }

}

extension UICollectionViewListCell {
  func keywordsConfiguration() -> PerfumeDetailKeywordsContentView.Configuration {
    PerfumeDetailKeywordsContentView.Configuration()
  }
}

extension PerfumeDetailKeywordsContentView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let label = UILabel().then {
      $0.font = .notoSans(type: .medium, size: 15)
      $0.text = "#\(self.keywords.value[indexPath.item])"
      $0.sizeToFit()
    }
    let size = label.frame.size
    
    return CGSize(width: size.width + 24, height: 30)
  }
}
