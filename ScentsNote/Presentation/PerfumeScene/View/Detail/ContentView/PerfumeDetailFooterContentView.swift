//
//  PerfumeDetailFooterContentView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/16.
//

import UIKit
import SnapKit
import Then

class PerfumeDetailFooterContentView: UIView, UIContentView {
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailFooterContentView(self)
    }
  }
  
  let dividerView = UIView().then { $0.backgroundColor = .blackText }
  
  var configuration: UIContentConfiguration
    
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.backgroundColor = .white
    self.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension UICollectionViewListCell {
  func footerConfiguration() -> PerfumeDetailFooterContentView.Configuration {
    PerfumeDetailFooterContentView.Configuration()
  }
}

