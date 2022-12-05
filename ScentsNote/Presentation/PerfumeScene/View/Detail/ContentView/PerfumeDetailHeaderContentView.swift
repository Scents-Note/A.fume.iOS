//
//  HeaderContentView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import Foundation

import UIKit
import SnapKit
import Then

class PerfumeDetailHeaderContentView: UIView, UIContentView {
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    var title: String? = ""
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailHeaderContentView(self)
    }
  }
  
  let titleLabel = UILabel().then {
    $0.font = .notoSans(type: .regular, size: 14)
    $0.textColor = .darkGray7d
  }
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(configuration: UIContentConfiguration) {
    guard let configuration = configuration as? Configuration else { return }
    titleLabel.text = configuration.title ?? "" + "."
  }

}

extension UICollectionViewListCell {
  func headerConfiguration() -> PerfumeDetailHeaderContentView.Configuration {
    PerfumeDetailHeaderContentView.Configuration()
  }
}

