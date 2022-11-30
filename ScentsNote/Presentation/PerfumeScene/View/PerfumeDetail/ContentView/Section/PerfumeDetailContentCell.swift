//
//  PerfumeDetailContentCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import SnapKit
import Then

final class PerfumeDetailContentCell: UICollectionViewCell {
  
  // MARK: - UI
  private let infoButton = UIButton().then {
    $0.setTitle("향수 정보", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 18)
  }
  private let noteButton = UIButton().then {
    $0.setTitle("시향 노트", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .regular, size: 14)
  }
  
  private lazy var tabView = Tabview(buttons: [self.infoButton, self.noteButton])
  
  lazy var pageViewController: UIPageViewController = {
    let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    return vc
  }()
  
  // MARK: - Vars & Lets
  var dataSourceVC: [UIViewController] = []
  var onUpdateHeight: (() -> Void)?
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setViewControllersInPageVC()
    self.configureUI()
    self.configureDelegate()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func setViewControllersInPageVC() {
    let infoVC = PerfumeDetailInfoViewController()
    infoVC.onUpdateHeight = { [weak self] height in
      Log(height)
      self?.updateHeight(height: height)
    }
    infoVC.collectionView.delegate = self
    
    let reviewVC = PerfumeDetailReviewViewController()
    reviewVC.onUpdateHeight = { [weak self] height in
      Log(height)
      self?.updateHeight(height: height)
    }
    
    dataSourceVC += [infoVC, reviewVC]
    pageViewController.setViewControllers([infoVC], direction: .forward, animated: true, completion: nil)
  }
  
  private func configureUI() {
    self.contentView.addSubview(self.tabView)
    self.tabView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    self.contentView.addSubview(self.pageViewController.view)
    self.pageViewController.view.snp.makeConstraints {
      $0.top.equalTo(self.tabView.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalTo(2000)
    }
  }
  
  private func configureDelegate() {
    pageViewController.delegate = self
    pageViewController.dataSource = self
  }
  
  func setViewModel(viewModel: PerfumeDetailViewModel?){
    (self.dataSourceVC[1] as! PerfumeDetailReviewViewController).setViewModel(viewModel: viewModel)
  }
  
  func updateUI(perfuemDetail: PerfumeDetail) {
    (self.dataSourceVC[0] as! PerfumeDetailInfoViewController).updateSnapshot(perfumeDetail: perfuemDetail)
  }
  
  private func updateHeight(height: CGFloat) {
    DispatchQueue.main.async {
      self.pageViewController.view.snp.updateConstraints {
        Log(height)
        $0.height.equalTo(height)
      }
      self.onUpdateHeight?()
    }
  }
}

extension PerfumeDetailContentCell: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = dataSourceVC.firstIndex(of: viewController) else { return nil }
    let previousIndex = index - 1
    if previousIndex < 0 {
      return nil
    }
    return dataSourceVC[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = dataSourceVC.firstIndex(of: viewController) else { return nil }
    let nextIndex = index + 1
    if nextIndex == dataSourceVC.count {
      return nil
    }
    return dataSourceVC[nextIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard let currentVC = pageViewController.viewControllers?.first,
          let currentIndex = dataSourceVC.firstIndex(of: currentVC) else { return }
    Log(currentIndex)
  }

}

extension PerfumeDetailContentCell: UIScrollViewDelegate, UICollectionViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // 1: determining whether scrollview is scrolling up or down
    //    let parentScrollView = self.scrollView
//    let scroll = (self.dataSourceVC[0] as! PerfumeDetailInfoViewController).collectionView

    //    Log(childScrollView.contentSize.height)
//    if size != scroll.contentSize.height {
//      self.pageViewController.view.snp.updateConstraints {
//        $0.height.equalTo(scroll.contentSize.height)
//      }
//    }
  }
}



