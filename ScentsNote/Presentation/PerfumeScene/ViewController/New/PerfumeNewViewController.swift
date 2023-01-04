//
//  PerfumeNewViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then

final class PerfumeNewViewController: UIViewController {
  typealias DataSource = RxCollectionViewSectionedNonAnimatedDataSource<PerfumeDataSection.Model>
  
  // MARK: - Vars & Lets
  var viewModel: PerfumeNewViewModel?
  var dataSource: DataSource!
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let reportView = UIView().then { $0.backgroundColor = .lightGray }
  private let reportLabel = UILabel().then {
    $0.text = "원하는 향수가 없으신가요?"
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let reportButton = UIButton().then {
    $0.setTitle("향수 및 브랜드 제보하기", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .regular, size: 12)
    $0.setImage(.btnNext?.withRenderingMode(.alwaysTemplate), for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
    $0.tintColor = .darkGray7d
  }
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.gridCompositionalLayout()).then {
    $0.showsVerticalScrollIndicator = false
    $0.backgroundColor = .white
    $0.register(PerfumeNewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    $0.register(HomeNewCell.self)
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setNavigationBar(title: "새로 등록된 향수")
    let cellInput = self.setupCollectionView()
    self.configureUI()
    self.bindViewModel(cellInput: cellInput)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  
  // MARK: - Configure UI
  private func setupCollectionView() -> PerfumeNewViewModel.CellInput {
    let perfumeClicked = PublishRelay<Perfume>()
    let perfumeHeartClicked = PublishRelay<Perfume>()
    
    self.dataSource = DataSource { dataSource, tableView, indexPath, item in
      let cell = self.collectionView.dequeueReusableCell(HomeNewCell.self, for: indexPath)
      cell.updateUI(perfume: item.perfume)
      cell.onPerfumeClick()
        .subscribe(onNext: { _ in
          perfumeClicked.accept(item.perfume)
      })
      .disposed(by: cell.disposeBag)
      cell.onHeartClick()
        .subscribe(onNext: {
          perfumeHeartClicked.accept(item.perfume)
        })
        .disposed(by: cell.disposeBag)
      return cell
    }
    
    self.dataSource.configureSupplementaryView = { dataSource, collectionView, kind, indexPath in
      if kind == UICollectionView.elementKindSectionHeader {
        let section = collectionView.dequeueReusableHeaderView(PerfumeNewHeaderView.self, for: indexPath)
        return section
      } else {
        return UICollectionReusableView()
      }
    }
    
    return PerfumeNewViewModel.CellInput(perfumeDidTapEvent: perfumeClicked,
                                         perfumeHeartDidTapEvent: perfumeHeartClicked)
                                         
  }
  
  private func configureUI() {
    self.view.backgroundColor = .white
    
    self.view.addSubview(self.reportView)
    self.reportView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(36)
    }
    
    self.reportView.addSubview(self.reportLabel)
    self.reportLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().offset(18)
    }
    
    self.reportView.addSubview(self.reportButton)
    self.reportButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.right.equalToSuperview().offset(-18)
    }
    
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.reportView.snp.bottom)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
    }
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel(cellInput: PerfumeNewViewModel.CellInput) {
    let input = PerfumeNewViewModel.Input(
      reportButtonDidTapEvent: self.reportButton.rx.tap.asObservable()
    )
    let output = viewModel?.transform(from: input, from: cellInput, disposeBag: self.disposeBag)
    self.bindPerfumesNew(output: output)
  }
  
  private func bindPerfumesNew(output: PerfumeNewViewModel.Output?) {
    output?.perfumes
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
  }
}
