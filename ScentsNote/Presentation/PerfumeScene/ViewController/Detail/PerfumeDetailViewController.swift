//
//  PerfumeViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then
import Toast_Swift

final class PerfumeDetailViewController: UIViewController {
  typealias DataSource = RxCollectionViewSectionedNonAnimatedDataSource<PerfumeDetailDataSection.Model>
  
  var updatePageView: ((Int, Int) -> Void)?
  var updateTabView: ((PerfumeDetailTabCell.TabType) -> Void)?
  
  // MARK: - Vars & Lets
  var viewModel: PerfumeDetailViewModel!
  var dataSource: DataSource!
  let disposeBag = DisposeBag()
  
  deinit {
    Log("deinit")
  }

  // MARK: - UI
  private let mainImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  private let brandLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .bold, size: 14)
  }
  
  private lazy var collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout).then {
    $0.showsVerticalScrollIndicator = false
    $0.register(PerfumeDetailTabCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    $0.register(PerfumeDetailTitleCell.self)
    $0.register(PerfumeDetailContentCell.self)
  }
  
  private let dividerView = UIView().then { $0.backgroundColor = .lightGray }
  private let bottomView = UIView()
  private let wishView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 2
    $0.layer.borderColor = UIColor.grayCd.cgColor
    $0.layer.borderWidth = 0.5
  }
  private let wishHeartView = UIImageView()
  private let wishLabel = UILabel().then {
    $0.text = "위시"
    $0.textColor = .blackText
    $0.font = .systemFont(ofSize: 12, weight: .regular)
  }
  
  private let reviewButton = UIButton().then {
    $0.setTitle("시향 노트 쓰기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 18)
    $0.backgroundColor = .blackText
    $0.layer.cornerRadius = 2
  }
  
  private let dividerViewOfBottomView = UIView().then { $0.backgroundColor = .lightGray }
  
  private lazy var collectionViewLayout = UICollectionViewCompositionalLayout (sectionProvider: { section, env -> NSCollectionLayoutSection? in
    let section = self.dataSource.sectionModels[section].model
    switch section {
    case .title:
      return self.getTitleSection()
    case .content:
      return self.getContentSection()
    }
  }, configuration: UICollectionViewCompositionalLayoutConfiguration().then {
    $0.interSectionSpacing = 32
  })
    .then {
      $0.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background-lightGray")
    }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  private func configureUI() {
    self.configureNavigation()
    self.configureCollectionView()

    self.view.backgroundColor = .white
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.bottomView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalTo(self.bottomView.snp.top)
      $0.left.right.equalToSuperview()
    }
    
    self.bottomView.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(72)
    }
    
    self.bottomView.addSubview(self.wishView)
    self.wishView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().offset(18)
      $0.width.equalTo(90)
      $0.height.equalTo(52)
    }
    
    self.bottomView.addSubview(self.dividerViewOfBottomView)
    self.dividerViewOfBottomView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    self.wishView.addSubview(self.wishHeartView)
    self.wishHeartView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(4)
      $0.size.equalTo(24)
    }
    
    self.wishView.addSubview(self.wishLabel)
    self.wishLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-4)
    }
    
    self.bottomView.addSubview(self.reviewButton)
    self.reviewButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalTo(self.wishView.snp.right).offset(17)
      $0.right.equalToSuperview().offset(-18)
      $0.height.equalTo(52)
    }
  }
  
  private func configureCollectionView() {
    let input = self.viewModel.input
    let childInput = self.viewModel.childInput
    
    self.dataSource = DataSource(
      configureCell: { [weak self] dataSource, tableView, indexPath, item in
        switch item {
        case .title(let perfumeDetail):
          let cell = self?.collectionView.dequeueReusableCell(PerfumeDetailTitleCell.self, for: indexPath)
          guard let cell = cell else { return UICollectionViewCell()}
          cell.updateUI(perfumeDetail: perfumeDetail)
            cell.clickCompareViewSubject.subscribe(onNext: { [weak self] _ in
                childInput.comparePriceTapEvent.accept(())
            }).disposed(by: cell.disposeBag)
          return cell
        case .content(let perfumeDetail):
          let cell = self?.collectionView.dequeueReusableCell(PerfumeDetailContentCell.self, for: indexPath)
          guard let cell = cell else { return UICollectionViewCell()}
          cell.updateUI(perfuemDetail: perfumeDetail)
          cell.onUpdateHeight = {
            self?.reload()
          }
          cell.clickPerfume = { perfume in
            childInput.perfumeDidTapEvent.accept(perfume.perfumeIdx)
          }
          cell.clickSuggestion = {
            childInput.suggestionDidTapEvent.accept(())
          }
          cell.setViewModel(viewModel: self?.viewModel)
          self?.updatePageView = { oldValue, newValue in
            cell.updatePageView(oldValue: oldValue, newValue: newValue)
          }
          return cell
        }
      }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
        if kind == UICollectionView.elementKindSectionHeader {
          let section = collectionView.dequeueReusableHeaderView(PerfumeDetailTabCell.self, for: indexPath)
          section.clickInfoButton()
            .subscribe(onNext: {
              input.tabButtonTapEvent.accept(0)
            })
            .disposed(by: section.disposeBag)
          section.clickReviewButton()
            .subscribe(onNext: {
              input.tabButtonTapEvent.accept(1)
            })
            .disposed(by: section.disposeBag)
          self?.updateTabView = { type in
            section.updateUI(type: type)
          }
          return section
        } else {
          return UICollectionReusableView()
        }
      })
  }
  
  private func configureNavigation() {
    self.setBackButton()
  }
  
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.wishView.rx.tapGesture().when(.recognized).map { _ in}
      .bind(to: input.likeButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.reviewButton.rx.tap
      .bind(to: input.reviewButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    
    self.bindContent(output: output)
    self.bindBottomView(output: output)
    self.bindToast(output: output)
  }
  
  private func bindContent(output: PerfumeDetailViewModel.Output) {
    output.perfumeDetailDatas
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
    
    Observable.zip(output.pageViewPosition, output.pageViewPosition.skip(1))
      .asDriver(onErrorJustReturn: (0,1))
      .drive(onNext: { [weak self] oldValue, newValue in
        self?.updatePageView?(oldValue, newValue)
        self?.updateTabView?(PerfumeDetailTabCell.TabType(rawValue: newValue) ?? .info)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindBottomView(output: PerfumeDetailViewModel.Output) {
    output.perfumeDetail
      .asDriver()
      .drive(onNext: { [weak self] detail in
        self?.setReviewState(detail: detail)
      })
      .disposed(by: self.disposeBag)
    
    output.isLiked
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] isLike in
        self?.updatePerfumeLike(isLike: isLike)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindToast(output: PerfumeDetailViewModel.Output) {
    output.showToast
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        self?.view.makeToast("신고 되었습니다.")
      })
      .disposed(by: self.disposeBag)
    
  }
  
  private func setReviewState(detail: PerfumeDetail?) {
    guard let detail = detail else { return }
    self.reviewButton.setTitle(detail.reviewIdx != 0 ? "시향 노트 수정" : "시향 노트 쓰기", for: .normal)
  }
  
  private func updatePerfumeLike(isLike: Bool) {
    self.wishHeartView.image = isLike ? .favoriteActive : .favoriteInactive
  }
  
  private func reload() {
    self.collectionView.reloadData()
  }
}
