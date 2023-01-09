//
//  SurveyViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/28.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

import SnapKit
import Then

final class SurveyViewController: UIViewController {
  
  var currentPage = 0
  
  var viewModel: SurveyViewModel?
  private let disposeBag = DisposeBag()
  
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
  
  private let highlightView = UIView().then {
    $0.backgroundColor = .black
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
  
  private let surveyScrollView = SurveyScrollView()
  private let backButton = UIBarButtonItem(image: .btnClose, style: .plain, target: .none, action: .none)
  private let doneButton = DoneButton(title: "다음")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
    
    self.configureDelegate()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
}

extension SurveyViewController {
  private func configureUI() {
    self.view.backgroundColor = .white
    self.backButton.tintColor = .blackText
    self.navigationItem.rightBarButtonItem = self.backButton
    
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
    
    self.view.addSubview(self.highlightView)
    self.highlightView.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width / 3)
      $0.bottom.equalTo(self.dividerView)
      $0.height.equalTo(4)
    }
    
    self.view.addSubview(self.doneButton)
    self.doneButton.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(86)
    }
    
    self.view.addSubview(self.surveyScrollView)
    self.surveyScrollView.snp.makeConstraints {
      $0.top.equalTo(self.dividerView.snp.bottom)
      $0.bottom.equalTo(self.doneButton.snp.top)
      $0.left.right.equalToSuperview()
    }
  }
  private func configureDelegate() {
    self.surveyScrollView.delegate = self
    self.surveyScrollView.configureDelegate(self)
  }
}

extension SurveyViewController {
  private func bindViewModel() {
    let input = SurveyViewModel.Input(
      perfumeButtonDidTapEvent: self.perfumeButton.rx.tap.asObservable(),
      keywordButtonDidTapEvent: self.keywordButton.rx.tap.asObservable(),
      seriesButtonDidTapEvent: self.seriesButton.rx.tap.asObservable(),
      exitAlertShownEvent: self.backButton.rx.tap.asObservable(),
      doneButtonDidTapEvent: self.doneButton.rx.tap.asObservable()
    )
    let output = self.viewModel?.transform(from: input, disposeBag: disposeBag)
    self.bindTab(output: output)
    self.bindPerfumes(output: output)
    self.bindExit(output: output)
  }
  
  private func bindTab(output: SurveyViewModel.Output?) {
    self.viewModel?.selectedTab
      .subscribe(onNext: { [weak self] idx in
        self?.updateTab(idx)
        self?.updatePage(idx)
        self?.updateButton(idx)
      })
      .disposed(by: disposeBag)
    
    output?.hightlightViewTransform
      .subscribe(onNext: {  [weak self] idx in
        UIView.animate(withDuration: 0.3) {
          self?.highlightView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * CGFloat(idx) / 3, y: 0)
          self?.highlightView.layoutIfNeeded()
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func bindPerfumes(output: SurveyViewModel.Output?) {
    output?.loadData
      .asDriver()
      .drive(onNext: { [weak self] _ in
        self?.surveyScrollView.surveyPerfumeView.setDatas(perfumes: self?.viewModel?.perfumes)
        self?.surveyScrollView.reload()
      })
      .disposed(by: disposeBag)
    
    output?.perfumeCellDidTap
      .subscribe(onNext: { [weak self] indexPath in
        print(indexPath.row)
        self?.surveyScrollView.surveyPerfumeView.reloadItems(at: [indexPath])
        
      })
      .disposed(by: disposeBag)
  }
  
  private func bindExit(output: SurveyViewModel.Output?) {
    output?.exitAlertShown
      .subscribe(onNext: { [weak self] _ in
        self?.presentAlert(message: "나에게 꼭 맞는 향수를 추천받고 싶다면 설문을 완료해주세요. 그래도 설문을 종료하시겠습니다?", completion: {
          self?.viewModel?.exit()
        })
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
  
  private func updatePage(_ idx: Int) {
    self.surveyScrollView.updatePage(idx)
  }
  
  private func updateButton(_ idx: Int) {
    if idx == 2 {
      self.doneButton.setTitle("완료", for: .normal)
    } else {
      self.doneButton.setTitle("다음", for: .normal)
    }
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
  
//  func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
//    UIView.performWithoutAnimation {
//      super.collectionView(collectionView, observedEvent: observedEvent)
//    }
//  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.frame.origin.x == 0 {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyPerfumeCollectionViewCell.identifier, for: indexPath) as? SurveyPerfumeCollectionViewCell else {
        return UICollectionViewCell()
      }
      let perfume = self.viewModel?.perfumes[indexPath.row]
      cell.updateUI(perfume: perfume)
      cell.clickPerfume = { [weak self] in
        self?.viewModel?.perfumes[indexPath.row].isLiked.toggle()
        UIView.performWithoutAnimation {
          self?.surveyScrollView.surveyPerfumeView.reloadItems(at: [indexPath])
        }
      }
      return cell
    } else if collectionView.frame.origin.x == UIScreen.main.bounds.width {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyKeywordCollectionViewCell.identifier, for: indexPath) as? SurveyKeywordCollectionViewCell else {
        return UICollectionViewCell()
      }
      let keyword = self.viewModel?.keywords[indexPath.row]
      cell.updateUI(keyword: keyword)
      cell.clickKeyword()
        .subscribe(onNext: { [weak self] _ in
          self?.viewModel?.keywords[indexPath.row].isSelected.toggle()
          UIView.performWithoutAnimation {
            self?.surveyScrollView.surveyKeywordView.reloadItems(at: [indexPath])
          }
        })
        .disposed(by: cell.disposeBag)
      return cell
    } else {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveySeriesCollectionViewCell.identifier, for: indexPath) as? SurveySeriesCollectionViewCell else {
        return UICollectionViewCell()
      }
      let series = self.viewModel?.series[indexPath.row]
      cell.updateUI(series: series)
      cell.clickSeries = { [weak self] in
        self?.viewModel?.series[indexPath.row].isLiked!.toggle()
        UIView.performWithoutAnimation {
          self?.surveyScrollView.surveySeriesView.reloadItems(at: [indexPath])
        }
      }
      return cell
    }
  }
}

extension SurveyViewController: UICollectionViewDelegateFlowLayout {
  
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyKeywordCollectionViewCell.identifier, for: indexPath) as? SurveyKeywordCollectionViewCell else {
      return CGSize(width: self.view.frame.width, height: SurveyPerfumeCollectionViewCell.height)
    }
    
    let label = UILabel().then {
      $0.font = .notoSans(type: .regular, size: 15)
      $0.text = self.viewModel?.keywords[indexPath.row].name ?? ""
      $0.sizeToFit()
    }
    let size = label.frame.size
    
    return CGSize(width: size.width + 50, height: 42)
  }
}

extension SurveyViewController: UIScrollViewDelegate {
  
  func isScrollViewHorizontalDragging() -> Bool {
    return self.surveyScrollView.contentOffset.x.remainder(dividingBy: self.surveyScrollView.frame.width) == 0
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let scrollView = (scrollView as? SurveyScrollView) else { return }
    //    guard !self.isScrollViewHorizontalDragging() else { return }
    
    UIView.animate(withDuration: 0.1) { [weak self] in
      self?.highlightView.transform = CGAffineTransform(translationX: scrollView.contentOffset.x / 3, y: 0)
      self?.highlightView.layoutIfNeeded()
    }
    
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    guard let _ = (scrollView as? SurveyScrollView) else { return }
    
    let index = Int(targetContentOffset.pointee.x / self.tabStackView.frame.width)
    self.viewModel?.selectedTab.accept(index)
  }
}

