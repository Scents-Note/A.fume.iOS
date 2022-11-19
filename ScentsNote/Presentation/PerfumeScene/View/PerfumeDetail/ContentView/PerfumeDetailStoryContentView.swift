//
//  PerfumeDetailStoryContentView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import SnapKit
import Then

class PerfumeDetailStoryContentView: UIView, UIContentView {
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    var text: String? = ""
    var onChange: (Date)->Void = { _ in }
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailStoryContentView(self)
    }
  }
  
  let contentLabel = UILabel().then {
    $0.font = .notoSans(type: .regular, size: 14)
    $0.textColor = .blackText
    $0.numberOfLines = 0
  }
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
//      $0.height.equalTo(200)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(configuration: UIContentConfiguration) {
    guard let configuration = configuration as? Configuration else { return }
    contentLabel.text = configuration.text
  }

}

extension UICollectionViewListCell {
  func storyConfiguration() -> PerfumeDetailStoryContentView.Configuration {
    PerfumeDetailStoryContentView.Configuration()
  }
}

