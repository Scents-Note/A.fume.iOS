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
import RxRelay
import SnapKit
import Then

final class PerfumeDetailViewController: UIViewController {
  typealias DataSource = RxCollectionViewSectionedNonAnimatedDataSource<PerfumeDetailDataSection.Model>
  
  var updatePageView: ((Int, Int) -> Void)?
  // MARK: - Vars & Lets
  var viewModel: PerfumeDetailViewModel?
  var dataSource: DataSource!
  let disposeBag = DisposeBag()
  
  // MARK: - Input
  private let pageViewState = BehaviorRelay<Int>(value: 0)
  
  // MARK: - UI
  private let mainImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  private let brandLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .bold, size: 14)
  }
  
  private lazy var collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout).then {
    $0.register(PerfumeDetailTabCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    $0.register(PerfumeDetailTitleCell.self)
    $0.register(PerfumeDetailContentCell.self)
  }
  
  private let dividerView = UIView().then { $0.backgroundColor = .lightGray }
  private let bottomView = UIView()
  private let wishView = UIView().then {
    $0.layer.borderColor = UIColor.grayCd.cgColor
    $0.layer.borderWidth = 0.5
  }
  private let wishHeartView = UIImageView()
  private let wishLabel = UILabel().then {
    $0.text = "위시"
    $0.textColor = .blackText
    $0.font = .notoSans(type: .regular, size: 11)
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
    self.configureCollectionView()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
}

extension PerfumeDetailViewController {
  
  private func configureCollectionView() {
    self.dataSource = DataSource(
      configureCell: { dataSource, tableView, indexPath, item in
        switch item {
        case .title(let perfumeDetail):
          let cell = self.collectionView.dequeueReusableCell(PerfumeDetailTitleCell.self, for: indexPath)
          cell.updateUI(perfumeDetail: perfumeDetail)
          return cell
        case .content(let perfumeDetail):
          let cell = self.collectionView.dequeueReusableCell(PerfumeDetailContentCell.self, for: indexPath)
          cell.updateUI(perfuemDetail: perfumeDetail)
          cell.onUpdateHeight = { [weak self] in
            self?.reload()
          }
          cell.clickPerfume = { [weak self] perfume in
            self?.viewModel?.cellInput.perfumeDidTapEvent.accept(perfume)
          }
          cell.updateUI(reviews: self.viewModel?.output.reviews)
          self.updatePageView = { oldValue, newValue in
            cell.updatePageView(oldValue: oldValue, newValue: newValue)
          }
          return cell
        }
      }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        if kind == UICollectionView.elementKindSectionHeader {
          let section = collectionView.dequeueReusableHeaderView(PerfumeDetailTabCell.self, for: indexPath)
          section.clickInfoButton()
            .subscribe(onNext: { [weak self] in
              self?.viewModel?.input.tabButtonTapEvent.accept(0)
            })
            .disposed(by: section.disposeBag)
          section.clickReviewButton()
            .subscribe(onNext: { [weak self] in
              self?.viewModel?.input.tabButtonTapEvent.accept(1)
            })
            .disposed(by: section.disposeBag)
          return section
        } else {
          return UICollectionReusableView()
        }
      })
  }
  
  private func configureUI() {
    self.configureNavigation()
    
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
  
  private func configureNavigation() {
    self.setBackButton()
  }
  
  private func bindViewModel() {
    let input = PerfumeDetailViewModel.Input(reviewButtonDidTapEvent: self.reviewButton.rx.tap.asObservable())
    self.viewModel?.transform(input: input, disposeBag: disposeBag)
    let output = self.viewModel?.output
    self.bindContent(output: output)
    
  }
  
  private func bindContent(output: PerfumeDetailViewModel.Output?) {
    guard let output = output else { return }
    
    output.models
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
    
    Observable.zip(output.pageViewPosition, output.pageViewPosition.skip(1))
      .subscribe(onNext: { [weak self] oldValue, newValue in
        self?.updatePageView?(oldValue, newValue)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func reload() {
    self.collectionView.reloadData()
  }
}
