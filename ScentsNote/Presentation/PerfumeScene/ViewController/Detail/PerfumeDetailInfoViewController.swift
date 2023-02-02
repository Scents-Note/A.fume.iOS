//
//  PerfumeDetailInfoViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

// Reative말고 Snapshot 사용해보기
final class PerfumeDetailInfoViewController: UIViewController {
  private typealias DataSource = UICollectionViewDiffableDataSource<PerfumeDetailInfoSection, PerfumeDetailInfoItem>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<PerfumeDetailInfoSection, PerfumeDetailInfoItem>
  
  // MARK: - Var
  var onUpdateHeight: ((CGFloat) -> Void)?
  var clickPerfume: ((Perfume) -> Void)?
  var clickSuggestion: (() -> Void)?
  
  private var datasource: DataSource!
  private let disposeBag = DisposeBag()
  var height: CGFloat = 0
  var isLoaded = false
  
  // MARK: - UI
  private lazy var stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.addArrangedSubview(self.penImageView)
    $0.addArrangedSubview(self.suggestLabel)
    $0.spacing = 4
  }
  
  private let penImageView = UIImageView().then {
    $0.image = .pen
  }
  private let suggestLabel = UILabel().then {
    $0.text = "정보 수정 제안"
    $0.textColor = .lightGray171
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout()).then {
    $0.isScrollEnabled = false
    $0.showsVerticalScrollIndicator = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureCollectionView()
    self.configureUI()
    self.bindUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.updateViewHeight()
  }
  
  // MARK: - Configure
  private func configureCollectionView() {
    let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
    self.datasource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
    }
  }
  
  private func configureUI() {
    self.view.addSubview(self.stackView)
    self.stackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.right.equalToSuperview().offset(-16)
    }
    
    self.penImageView.snp.makeConstraints {
      $0.size.equalTo(16)
    }
    
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints{
      $0.top.equalTo(self.suggestLabel.snp.bottom)
      $0.bottom.left.right.equalToSuperview().inset(16)
    }
  }
  
  private func bindUI() {
    self.stackView.rx.tapGesture().when(.recognized).asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.clickSuggestion?()
      })
      .disposed(by: self.disposeBag)
  }
  
  func updateSnapshot(perfumeDetail: PerfumeDetail) {
    guard !isLoaded else { return }
    var snapshot = Snapshot()
    snapshot.appendSections([.story, .keyword, .ingredient, .abundance, .price, .seasonal, .longevity, .sillage, .similarity])
    snapshot.appendItems([.header("조향 스토리"), .story(perfumeDetail.story), .footer("story")], toSection: .story)
    snapshot.appendItems([.header("키워드"), .keyword(perfumeDetail.Keywords), .footer("keyword")], toSection: .keyword)
    snapshot.appendItems([.header("노트"), .ingredient(perfumeDetail.ingredients), .footer("ingredient")], toSection: .ingredient)
    snapshot.appendItems([.header("부향률"), .abundance(perfumeDetail.abundanceRate), .footer("abundance")], toSection: .abundance)
    snapshot.appendItems([.header("가격"), .price(perfumeDetail.volumeAndPrice), .footer("price")], toSection: .price)
    snapshot.appendItems([.header("계절감"), .seasonal(perfumeDetail.seasonal), .footer("seasonal")])
    snapshot.appendItems([.header("지속력"), .longevity(perfumeDetail.longevity), .footer("longevity")])
    snapshot.appendItems([.header("잔향감"), .sillage(perfumeDetail.sillage), .footer("sillage")])
    snapshot.appendItems([.header("성별감"), .gender(perfumeDetail.gender), .footer("gender")])
    snapshot.appendItems([.header("지금 보는 향수와 비슷해요"), .similarity(perfumeDetail.similarPerfumes)])
    datasource.apply(snapshot) { [weak self] in
      self?.updateViewHeight()
      self?.isLoaded = true
    }
  }
  
  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
    listConfiguration.showsSeparators = false
    return UICollectionViewCompositionalLayout.list(using: listConfiguration)
  }
  
  private func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: PerfumeDetailInfoItem) {
    switch row {
    case .header(let title):
      cell.contentConfiguration = headerConfiguration(for: cell, with: title)
    case .footer:
      cell.contentConfiguration = footerConfiguration(for: cell)
    case .story(let story):
      cell.contentConfiguration = storyConfiguration(for: cell, with: story)
    case .keyword(let keywords):
      cell.contentConfiguration = keywordConfiguration(for: cell, with: keywords)
    case .ingredient(let ingredients):
      cell.contentConfiguration = ingredientConfiguration(for: cell, with: ingredients)
    case .abundance(let abundance):
      cell.contentConfiguration = abundanceConfiguration(for: cell, with: abundance)
    case .price(let prices):
      cell.contentConfiguration = priceConfiguration(for: cell, with: prices)
    case .seasonal(let seasonals):
      cell.contentConfiguration = seasonalConfiguration(for: cell, with: seasonals)
    case .longevity(let longevities):
      cell.contentConfiguration = longevityConfiguration(for: cell, with: longevities)
    case .sillage(let sillages):
      cell.contentConfiguration = sillageConfiguration(for: cell, with: sillages)
    case .gender(let genders):
      cell.contentConfiguration = genderConfiguration(for: cell, with: genders)
    case .similarity(let perfumes):
      cell.contentConfiguration = similarityConfiguration(for: cell, with: perfumes, with: clickPerfume)
    }
  }
  
  /// 똑같은 Layout Height 일 때 다시 측정되어 스크롤이 상단으로 움직이는 것을 방지
  private func updateViewHeight() {
    let heightUpdated = self.collectionView.contentSize.height
    if heightUpdated == 0 || heightUpdated == self.height {
      return
    }
    Log(heightUpdated)
    self.onUpdateHeight?(heightUpdated)
  }
  
}

