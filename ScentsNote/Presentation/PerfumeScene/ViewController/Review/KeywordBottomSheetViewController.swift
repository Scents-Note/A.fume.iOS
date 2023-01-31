//
//  KeywordBottomSheetViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/03.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class KeywordBottomSheetViewController: UIViewController {
  typealias DataSource = RxCollectionViewSectionedNonAnimatedDataSource<FilterKeywordDataSection.Model>
  
  // MARK: - UI
  private let dimmedBackView = UIView().then {
    $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
  }
  
  private let bottomSheetView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 14
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.clipsToBounds = true
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "키워드"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .extraBold, size: 22)
  }
  
  private let confirmButton = UIButton().then {
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.pointBeige, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 15)
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
  
  // MARK: - Vars & Lets
  var viewModel: KeywordBottomSheetViewModel!
  private var dataSource: DataSource!
  
  var bottomHeight: CGFloat = 0
  let disposeBag = DisposeBag()
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.bottomHeight = self.view.safeAreaLayoutGuide.layoutFrame.height / 2
    self.configureUI()
    self.configureDelegate()
    self.bindUI()
    self.bindViewModel()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showHalfBottomSheet()
  }
  
  private func configureUI() {
    self.configureCollectionView()
    self.dimmedBackView.alpha = 0.0
    
    self.view.addSubview(self.dimmedBackView)
    self.dimmedBackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    let topConstant = self.view.safeAreaInsets.bottom + self.view.safeAreaLayoutGuide.layoutFrame.height
    self.view.addSubview(self.bottomSheetView)
    self.bottomSheetView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(topConstant)
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(self.bottomHeight + self.view.safeAreaInsets.bottom)
    }
    
    self.bottomSheetView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(31)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.bottomSheetView.addSubview(self.confirmButton)
    self.confirmButton.snp.makeConstraints {
      $0.centerY.equalTo(self.titleLabel)
      $0.right.equalToSuperview().offset(-18)
    }
    
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(20)
      $0.bottom.left.right.equalToSuperview()
    }
  }
  
  private func configureDelegate() {
    self.collectionView.delegate = self
  }
  
  private func configureCollectionView() {
    let input = self.viewModel.input
    
    self.dataSource = DataSource { dataSource, collectionView, indexPath, item in
      let cell = self.collectionView.dequeueReusableCell(SurveyKeywordCollectionViewCell.self, for: indexPath)
      cell.updateUI(keyword: item.keyword)
      cell.clickKeyword()
        .subscribe(onNext: { _ in
          input.keywordCellDidTapEvent.accept(item.keyword)
        })
        .disposed(by: cell.disposeBag)
      return cell
    }
  }
  
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.confirmButton.rx.tap
      .bind(to: input.confirmButtonDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    output.keywords
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
    
    output.hideBottomSheet
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] _ in
        self?.hideBottomSheet()
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindUI() {
    self.dimmedBackView.rx.tapGesture()
      .asDriver()
      .skip(1)
      .drive(onNext: { [weak self] _ in
        self?.hideBottomSheet()
      })
      .disposed(by: self.disposeBag)
    
    self.bottomSheetView.rx.panGesture()
      .asDriver()
      .drive(onNext: { [weak self] pan in
        self?.handlePanGesture(pan: pan)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func showHalfBottomSheet() {
    self.viewModel.setState(state: .half)
    let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
    self.bottomHeight = safeAreaHeight / 2 + self.view.safeAreaInsets.bottom
    self.bottomSheetView.snp.updateConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(safeAreaHeight - self.bottomHeight)
    }
    
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.dimmedBackView.alpha = 0.5
      self.view.layoutIfNeeded()
    })
  }
  
  private func showFullBottomSheet() {
    self.viewModel.setState(state: .fill)
    let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
    self.bottomHeight = safeAreaHeight
    self.bottomSheetView.snp.updateConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(0)
    }
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  private func hideBottomSheet() {
    let topConstant = self.view.safeAreaInsets.bottom + self.view.safeAreaLayoutGuide.layoutFrame.height
    self.bottomSheetView.snp.updateConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(topConstant)
    }
    
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.dimmedBackView.alpha = 0
      self.view.layoutIfNeeded()
    }) { _ in
      if self.presentingViewController != nil {
        self.dismiss(animated: false, completion: nil)
      }
    }
  }
  
  private func handlePanGesture(pan: UIPanGestureRecognizer) {
    let offsetY = pan.translation(in: self.bottomSheetView).y
    let safeAreaHeight: CGFloat = self.view.safeAreaLayoutGuide.layoutFrame.height
    let state = self.viewModel.state
    switch pan.state {
    case .changed:
      self.bottomSheetView.snp.updateConstraints {
        $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(safeAreaHeight - self.bottomHeight + offsetY)
      }
    case .ended:
      switch state {
      case .half:
        if offsetY > 30.0 {
          self.hideBottomSheet()
        } else if offsetY < -30.0 {
          self.showFullBottomSheet()
        } else {
          self.showHalfBottomSheet()
        }
      case .fill:
        if offsetY > 500.0 {
          self.hideBottomSheet()
        } else if offsetY > 200 {
          self.showHalfBottomSheet()
        } else {
          self.showFullBottomSheet()
        }
      }
    default:
      break
    }
  }
}

extension KeywordBottomSheetViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view == self {
      return !(touch.view?.isDescendant(of: self.bottomSheetView) ?? true)
    }
    return false
  }
}

extension KeywordBottomSheetViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let label = UILabel().then {
      $0.font = .notoSans(type: .regular, size: 15)
      $0.text = self.viewModel.keywords[indexPath.item].name
      $0.sizeToFit()
    }
    let size = label.frame.size
    
    return CGSize(width: size.width + 50, height: 42)
  }
}
