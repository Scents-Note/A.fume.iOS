//
//  FilterKeywordView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxDataSources
import FirebaseAnalytics

final class FilterKeywordView: UIView {
  typealias DataSource = RxCollectionViewSectionedNonAnimatedDataSource<FilterKeywordDataSection.Model>
  
  // MARK: - Vars & Lets
  var viewModel: SearchFilterKeywordViewModel
  private var dataSource: DataSource!
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let notyView = UIView().then { $0.backgroundColor = .lightGray2 }
  private let notyLabel = UILabel().then {
    $0.text = "카테고리 당 최대 5개까지 중복 선택 가능합니다."
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    let layout = LeftAlignedCollectionViewFlowLayout()
    layout.minimumLineSpacing = 16
    layout.minimumInteritemSpacing = 16
    layout.sectionInset = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
    
    $0.collectionViewLayout = layout
    $0.backgroundColor = .white
    $0.register(SurveyKeywordCollectionViewCell.self)
  }
  
  // MARK: - Life Cycle
  init(viewModel: SearchFilterViewModel) {
    self.viewModel = SearchFilterKeywordViewModel(filterDelegate: viewModel,
                                                  fetchKeywordsUseCase: DefaultFetchKeywordsUseCase(keywordRepository: DefaultKeywordRepository.shared))
    super.init(frame: .zero)
    self.configureUI()
    self.configureDelegate()
    self.bindViewModel()
    Analytics.logEvent(GoogleAnalytics.Screen.filterKeyword, parameters: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.configureCollectionView()
    
    self.addSubview(self.notyView)
    self.notyView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(36)
    }
    
    self.notyView.addSubview(self.notyLabel)
    self.notyLabel.snp.makeConstraints {
      $0.centerY.centerX.equalToSuperview()
    }
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.notyView.snp.bottom)
      $0.bottom.left.right.equalToSuperview()
    }
  }
  
  private func configureCollectionView() {
    self.dataSource = DataSource { dataSource, collectionView, indexPath, item in
      let cell = self.collectionView.dequeueReusableCell(SurveyKeywordCollectionViewCell.self, for: indexPath)
      cell.updateUI(keyword: item.keyword)
      return cell
    }
  }
  
  private func configureDelegate() {
    self.collectionView.delegate = self
  }
  
  // MARK: - Bind ViewModel
  func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  func bindInput() {
    let input = self.viewModel.input
    
    self.collectionView.rx.itemSelected.map { $0.item }
      .subscribe(onNext: { idx in
        input.keywordCellDidTapEvent.accept(idx)
      })
      .disposed(by: self.disposeBag)
  }
  
  func bindOutput() {
    let output = self.viewModel.output
    
    output.keywordDataSource
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }
}

extension FilterKeywordView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let output = self.viewModel.output

    let label = UILabel().then {
      $0.font = .notoSans(type: .regular, size: 15)
      $0.text = output.keywordDataSource.value[0].items[indexPath.row].keyword.name
      $0.sizeToFit()
    }
    let size = label.frame.size

    return CGSize(width: size.width + 50, height: 42)
  }
}
