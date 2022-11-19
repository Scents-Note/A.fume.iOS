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
  enum Section: Int, Equatable, Hashable {
    case title
    case information
  }
  
  var dataSource: DataSource!
  
  let section: [Section] = [.title, .information]
  
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
  
  var viewModel: PerfumeDetailViewModel?
  let disposeBag = DisposeBag()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout).then {
    $0.register(PerfumeDetailTitleCell.self)
    $0.register(PerfumeDetailContentCell.self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureTableView()
    self.configureUI()
    self.bindViewModel()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
}

extension PerfumeDetailViewController {
  private func configureTableView() {
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
}

extension PerfumeDetailViewController {
  private func bindViewModel() {
    let input = PerfumeDetailViewModel.Input(
      
    )
    
    let output = viewModel?.transform(from: input, disposeBag: disposeBag)
    
    self.bindSection(output: output)
  }
  
  private func bindSection(output: PerfumeDetailViewModel.Output?) {
    output?.models
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
  }
}
