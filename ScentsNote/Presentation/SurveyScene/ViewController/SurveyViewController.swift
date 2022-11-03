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
  private var direction = 0
  
  private var barLeadingAnchor: Constraint?
  
  //  var perfumeDatas = [SurveyPerfume(perfumeIdx: 1, brandName: "22", name: "412", imageUrl: "", isLiked: true),SurveyPerfume(perfumeIdx: 1, brandName: "22", name: "412", imageUrl: "", isLiked: true),SurveyPerfume(perfumeIdx: 1, brandName: "22", name: "412", imageUrl: "", isLiked: true),SurveyPerfume(perfumeIdx: 1, brandName: "22", name: "412", imageUrl: "", isLiked: true),SurveyPerfume(perfumeIdx: 1, brandName: "22", name: "412", imageUrl: "", isLiked: true),SurveyPerfume(perfumeIdx: 1, brandName: "22", name: "412", imageUrl: "", isLiked: true),SurveyPerfume(perfumeIdx: 1, brandName: "22", name: "412", imageUrl: "", isLiked: true),SurveyPerfume(perfumeIdx: 1, brandName: "22", name: "412", imageUrl: "", isLiked: true)]
  //  var datas = [SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222"),SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222"),SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222"),SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222"),SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222"),SurveySeries(seriesIdx: 1, name: "11", imageUrl: "222")]
  //
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
  
  private lazy var tabStackView = UIStackView().then {
    $0.alignment = .fill
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    
    $0.addArrangedSubview(self.perfumeButton)
    $0.addArrangedSubview(self.keywordButton)
    $0.addArrangedSubview(self.seriesButton)
  }
  
  private let dividerView = UIView().then {
    $0.backgroundColor = .grayCd
  }
  
  private let selectedBarView = UIView().then {
    $0.backgroundColor = .blackText
  }
  
  private let perfumeButton = UIButton().then {
    $0.setTitle("향수", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .regular, size: 14)
  }
  
  private let keywordButton = UIButton().then {
    $0.setTitle("키워드", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .regular, size: 14)
  }
  
  private let seriesButton = UIButton().then {
    $0.setTitle("계열", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .regular, size: 14)
  }
  
  private let scrollView = SurveyScrollView()
  
  private let doneButton = DoneButton(frame: .zero, title: "다음")
  
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
    
    self.view.addSubview(self.tabStackView)
    self.tabStackView.snp.makeConstraints {
      $0.top.equalTo(self.contentLabel.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    self.view.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.top.equalTo(self.tabStackView.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    self.view.addSubview(self.selectedBarView)
    self.selectedBarView.snp.makeConstraints {
      barLeadingAnchor = $0.left.equalTo(self.perfumeButton.snp.left).constraint
      $0.width.equalTo(UIScreen.main.bounds.width / 3)
      $0.bottom.equalTo(self.dividerView)
      $0.height.equalTo(4)
    }
    barLeadingAnchor?.activate()
    
    self.view.addSubview(self.doneButton)
    self.doneButton.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(86)
    }
    
    self.view.addSubview(self.scrollView)
    self.scrollView.snp.makeConstraints {
      $0.top.equalTo(self.dividerView.snp.bottom)
      $0.bottom.equalTo(self.doneButton.snp.top)
      $0.left.right.equalToSuperview()
    }
  }
  private func configureDelegate() {
    self.scrollView.delegate = self
    self.scrollView.configureDelegate(self)
  }
  
  
}

extension SurveyViewController {
  private func bindViewModel() {
    let input = SurveyViewModel.Input(
      perfumeButtonDidTapEvent: self.perfumeButton.rx.tap.asObservable(),
      keywordButtonDidTapEvent: self.keywordButton.rx.tap.asObservable(),
      seriesButtonDidTapEvent: self.seriesButton.rx.tap.asObservable()
    )
    let output = self.viewModel?.transform(from: input, disposeBag: disposeBag)
    self.bindTab(output: output)
    self.bindPerfumes(output: output)
  }
  
  private func bindTab(output: SurveyViewModel.Output?) {
    self.viewModel?.selectedTab
      .subscribe(onNext: { [weak self] idx in
        self?.updateTab(idx)
        self?.updateTabBar(idx)
        self?.updatePage(idx)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindPerfumes(output: SurveyViewModel.Output?) {
    output?.loadData
      .asDriver()
      .drive(onNext: { [weak self] _ in
        self?.scrollView.reload()
      })
      .disposed(by: disposeBag)
  }
}

extension SurveyViewController {
  private func updateTab(_ idx: Int) {
    self.perfumeButton.do {
      $0.titleLabel?.font = .notoSans(type: idx == 0 ? .bold : .regular, size: 14)
      $0.setTitleColor(idx == 0 ? .blackText : .darkGray7d, for: .normal)
    }
    
    self.keywordButton.do {
      $0.titleLabel?.font = .notoSans(type: idx == 1 ? .bold : .regular, size: 14)
      $0.setTitleColor(idx == 1 ? .blackText : .darkGray7d, for: .normal)
    }
    
    self.seriesButton.do {
      $0.titleLabel?.font = .notoSans(type: idx == 2 ? .bold : .regular, size: 14)
      $0.setTitleColor(idx == 2 ? .blackText : .darkGray7d, for: .normal)
    }
  }
  
  private func updateTabBar(_ idx: Int) {
    self.barLeadingAnchor?.deactivate()
    if idx == 0 {
      self.selectedBarView.snp.makeConstraints {
        self.barLeadingAnchor = $0.left.equalTo(self.perfumeButton.snp.left).constraint
      }
    } else if idx == 1 {
      self.selectedBarView.snp.makeConstraints {
        self.barLeadingAnchor = $0.left.equalTo(self.keywordButton.snp.left).constraint
      }
    } else {
      self.selectedBarView.snp.makeConstraints {
        self.barLeadingAnchor = $0.left.equalTo(self.seriesButton.snp.left).constraint
      }
    }
    self.barLeadingAnchor?.activate()
//    UIView.animate(withDuration: 0.3) {
//      self.view.layoutIfNeeded()
//    }
  }
  
  private func updatePage(_ idx: Int) {
    self.scrollView.updatePage(idx)
  }
}

extension SurveyViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView.frame.origin.x == 0 {
      return self.viewModel?.perfumes.count ?? 0
    } else if collectionView.frame.origin.x == UIScreen.main.bounds.width {
      return self.viewModel?.keywords.count ?? 0
    } else {
      return self.viewModel?.series.count ?? 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.frame.origin.x == 0 {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyPerfumeCollectionViewCell.identifier, for: indexPath) as? SurveyPerfumeCollectionViewCell else {
        return UICollectionViewCell()
      }
      let perfume = self.viewModel?.perfumes[indexPath.row]
      cell.updateUI(perfume: perfume)
      return cell
    } else if collectionView.frame.origin.x == UIScreen.main.bounds.width {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyKeywordCollectionViewCell.identifier, for: indexPath) as? SurveyKeywordCollectionViewCell else {
        return UICollectionViewCell()
      }
      let keyword = self.viewModel?.keywords[indexPath.row]
      cell.updateUI(keyword: keyword)
      return cell
    } else {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveySeriesCollectionViewCell.identifier, for: indexPath) as? SurveySeriesCollectionViewCell else {
        return UICollectionViewCell()
      }
      let series = self.viewModel?.series[indexPath.row]
      cell.updateUI(series: series)
      return cell
    }
  }
}

extension SurveyViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width, height: SurveyPerfumeCollectionViewCell.height)
  }
}

extension SurveyViewController: UIScrollViewDelegate {

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//    guard !self.isScrollViewHorizontalDragging() else { return }
    if scrollView.contentOffset.x == 0 {
      if self.viewModel?.selectedTab.value != 0 {
        self.viewModel?.updateSelectedTab(0)
      }
    } else if scrollView.contentOffset.x == scrollView.frame.width * 2 {
      if self.viewModel?.selectedTab.value != 2 {
        self.viewModel?.updateSelectedTab(2)
      }
    } else {
      if self.viewModel?.selectedTab.value != 1 {
        self.viewModel?.updateSelectedTab(1)
      }
    }
  }
}

