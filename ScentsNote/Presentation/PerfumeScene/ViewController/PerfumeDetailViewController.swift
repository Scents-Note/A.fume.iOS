//
//  PerfumeViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then

final class PerfumeDetailViewController: UIViewController {
  typealias DataSource = RxCollectionViewSectionedNonAnimatedDataSource<PerfumeDetailDataSection.Model>
  
  
  // MARK: - UI
  private let mainImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  private let brandLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .bold, size: 14)
  }
  
  private lazy var collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout).then {
    $0.register(PerfumeDetailTitleCell.self)
    $0.register(PerfumeDetailContentCell.self)
  }
  
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
  
  private let scrollView = UIScrollView()
  private let infoButton = UIButton().then { $0.setTitle("향수 정보", for: .normal) }
  private let nameLabel = UILabel()
  private let noteButton = UIButton().then { $0.setTitle("시향 노트", for: .normal) }
  private lazy var tabView = Tabview(buttons: [self.infoButton, self.noteButton])
  
  // MARK: - Vars & Lets
  var viewModel: PerfumeDetailViewModel?
  var dataSource: DataSource!
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureCollectionView()
    self.configureUI()
    self.bindViewModel()
    
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//          self.collectionView.layoutIfNeeded()
//          self.collectionView.reloadData()
//          Log("reload")
//    
//        }
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
          return cell
        }
      })
  }
  
  private func configureUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.left.right.equalToSuperview()
    }
  }
  
  private func bindViewModel() {
    let input = PerfumeDetailViewModel.Input(
      
    )
    
    let output = viewModel?.transform(from: input, disposeBag: disposeBag)
    output?.models
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
  }
  
  private func reload() {
    self.collectionView.reloadData()
  }
}
