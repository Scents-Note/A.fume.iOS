//
//  PerfumeViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import UIKit

final class PerfumeDetailViewController: UIViewController {
  var viewModel: PerfumeDetailViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
}

extension PerfumeDetailViewController {
  private func configureUI() {
    self.view.backgroundColor = .white
  }
}
