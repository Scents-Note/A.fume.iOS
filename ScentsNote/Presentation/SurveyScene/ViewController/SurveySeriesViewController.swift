//
//  SurveyListViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import UIKit

final class SurveySeriesViewController: UIViewController {
  
  private let color: UIColor
  
  init(_ color: UIColor) {
    self.color = color
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = color
  }
}
