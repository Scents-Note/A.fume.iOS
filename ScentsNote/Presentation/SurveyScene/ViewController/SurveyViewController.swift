//
//  SurveyViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/28.
//

import UIKit

import RxGesture
import RxSwift
import RxCocoa

import SnapKit
import Then

final class SurveyViewController: UIViewController {
  
  var currentPage = 0
  
  var viewModel: SurveyViewModel?
  private let disposeBag = DisposeBag()
  var datas = [SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222"),SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222"),SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222"),SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222"),SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222"),SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222")]
  
  private let titleLabel = UILabel().then {
    $0.text = "회원가입을 축하합니다!\n어떤 향을 좋아하세요?"
    $0.textColor = .blackText
    $0.numberOfLines = 2
    $0.font = .nanumMyeongjo(type: .extraBold, size: 20)
  }
  
  private let contentLabel = UILabel().then {
    $0.text = "취향을 선택하고 나에게 맞는 향수를\n추천 받아보세요."
    $0.textColor = .darkGray7d
    $0.numberOfLines = 2
    $0.font = .nanumMyeongjo(type: .regular, size: 15)
  }
  
//  private func collectionViewLayout() -> UICollectionViewLayout {
//    let cellInterval: CGFloat = 1
//
//    let layout = UICollectionViewFlowLayout()
//    layout.scrollDirection = .vertical
//    layout.sectionInset = UIEdgeInsets(
//      top: cellInterval,
//      left: 0,
//      bottom: cellInterval,
//      right: 0)
//    layout.minimumInteritemSpacing = cellInterval
//    layout.minimumLineSpacing = cellInterval
//    layout.sectionHeadersPinToVisibleBounds = true
//    print("두번")
//    return layout
//  }
  
  var surveySeriesView = SurveySeriesView()

//  private lazy var seriesCollectionView: UICollectionView = {
//    let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: self.collectionViewLayout())
//    collectionView.backgroundColor = .white
//    collectionView.register(SurveySeriesCollectionViewCell.self, forCellWithReuseIdentifier: SurveySeriesCollectionViewCell.identifier)
//    print("sefklnsaeifhasioehj")
//    return collectionView
//  }()
  
  private let scrollView = SurveyScrollView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
    
    self.configureDelegate()
    
    self.scrollView.reload()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    
  }
}

extension SurveyViewController {
  private func configureUI() {
    self.view.backgroundColor = .white
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .checkmark, style: .plain, target: .none, action: .none)
    
    self.view.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
      $0.left.equalToSuperview().offset(20)
    }
    
    self.view.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
      $0.left.equalToSuperview().offset(20)
    }

//    surveySeriesView.delegate = self
//    surveySeriesView.dataSource = self
//    self.view.addSubview(self.surveySeriesView)
//    self.surveySeriesView.snp.makeConstraints {
//      $0.top.equalTo(self.contentLabel.snp.bottom)
//      $0.left.right.bottom.equalToSuperview()
//    }
    self.scrollView.delegate = self
    self.view.addSubview(self.scrollView)
    self.scrollView.snp.makeConstraints {
      $0.top.equalTo(self.contentLabel.snp.bottom)
      $0.left.right.bottom.equalToSuperview()
    }
  }
  private func configureDelegate() {
    self.scrollView.configureDelegate(self)
    self.scrollView.delegate = self
    
  
  }
  
  
}

extension SurveyViewController {
  private func bindViewModel() {
    
  }
}

extension SurveyViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    let regionCount = 1
    print(datas.count)
    if collectionView.frame.origin.x == 0 {
      return self.datas.count == 0 ? 0 : regionCount
    }
    else {
      return self.datas.count == 0 ? 0 : regionCount
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView.frame.origin.x == 0 {
      print(self.datas.count)
      return self.datas.count
    }
    else {
      return self.datas.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveySeriesCollectionViewCell.identifier, for: indexPath) as? SurveySeriesCollectionViewCell else {
      print("sefsefjisefil")
      return UICollectionViewCell()
      
    }
    let info = self.datas[indexPath.row]
    cell.updateUI(seriesInfo: info)
    print("cell")
    return cell
  }

}

extension SurveyViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width, height: SurveySeriesCollectionViewCell.height)
  }
}

extension SurveyViewController: UIScrollViewDelegate {
  func isScrollViewHorizontalDragging() -> Bool {
      return self.scrollView.contentOffset.x.remainder(dividingBy: self.scrollView.frame.width) == 0
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // TODO: Bug Fix
    guard !self.isScrollViewHorizontalDragging() else { return }
//    self.currentSearchType = scrollView.contentOffset.x > scrollView.frame.width / 2 ? SearchType.station : SearchType.bus
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    guard let scrollView = (scrollView as? SurveyScrollView),
          let indicator = scrollView.subviews.last?.subviews.first else { return }
    
    let twice: CGFloat = 2
    let indicatorWidthPadding: CGFloat = 5
    
//    scrollView.configureIndicator(true)
    scrollView.horizontalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: -indicatorWidthPadding, bottom: scrollView.frame.height - (3 * twice), right: -indicatorWidthPadding)
    indicator.layer.cornerRadius = 0
    indicator.backgroundColor = .blue
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard let scrollView = (scrollView as? SurveyScrollView) else { return }
//    scrollView.configureIndicator(false)
  }
}
