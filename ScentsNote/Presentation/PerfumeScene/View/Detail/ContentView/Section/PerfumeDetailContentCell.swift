//
//  PerfumeDetailContentCell.swift
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

final class PerfumeDetailContentCell: UICollectionViewCell {
  
  // MARK: - Output
  var onUpdateHeight: (() -> Void)?
  
  var clickPerfume: ((Perfume) -> Void)? {
    didSet {
      self.bindAction(clickPerfume: clickPerfume)
    }
  }
  
  // MARK: - UI
  lazy var pageViewController: UIPageViewController = {
    let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    return vc
  }()
  
  // MARK: - Vars & Lets
  var dataSourceVC: [UIViewController] = []
  private let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setViewControllersInPageVC()
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func setViewControllersInPageVC() {
    let infoVC = PerfumeDetailInfoViewController()
    infoVC.onUpdateHeight = { [weak self] height in
      self?.updateHeight(height: height)
    }
    
    let reviewVC = PerfumeDetailReviewViewController()
    reviewVC.onUpdateHeight = { [weak self] height in
      self?.updateHeight(height: height)
    }
    
    dataSourceVC += [infoVC, reviewVC]
    pageViewController.setViewControllers([infoVC], direction: .forward, animated: false, completion: nil)
  }
  
  private func configureUI() {
    self.contentView.addSubview(self.pageViewController.view)
    self.pageViewController.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(2000)
    }
  }
  
  func updateUI(perfuemDetail: PerfumeDetail) {
    let vc = self.dataSourceVC[0] as! PerfumeDetailInfoViewController
    vc.updateSnapshot(perfumeDetail: perfuemDetail)
  }
  
  func setViewModel(viewModel: PerfumeDetailViewModel?) {
    let vc = self.dataSourceVC[1] as! PerfumeDetailReviewViewController
    vc.viewModel = viewModel
  }
  
  private func updateHeight(height: CGFloat) {
    DispatchQueue.main.async {
      self.pageViewController.view.snp.updateConstraints {
        $0.height.equalTo(height)
      }
      self.onUpdateHeight?()
    }
  }
  
  func updatePageView(oldValue: Int, newValue: Int) {
    self.pageViewController.setViewControllers([self.dataSourceVC[newValue]], direction: .forward, animated: false, completion: nil)
  }
  
  func bindAction(clickPerfume: ((Perfume) -> Void)?) {
    (self.dataSourceVC[0] as! PerfumeDetailInfoViewController).clickPerfume = clickPerfume
  }
}



