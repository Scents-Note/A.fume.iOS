//
//  PerfumeReviewViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then
import Cosmos
import Toast_Swift


final class PerfumeReviewViewController: UIViewController {
  
  // MARK: - UI
  
  // Label
  private let detailLabel = UILabel().then {
    $0.text = "상품 자세히 보기"
    $0.textColor = .darkGray7d
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }
  
  private let brandLabel = UILabel().then {
    $0.textColor = .darkGray7d
    $0.font = .nanumMyeongjo(type: .regular, size: 16)
  }
  private let nameLabel = UILabel().then {
    $0.textColor = .black1d
    $0.font = .systemFont(ofSize: 24, weight: .bold)
  }
  private let recordLabel = UILabel().then {
    $0.text = "향을 오래 기억할 수 있도록 기록해볼까요?"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
  }
  private let scoreLabel = UILabel().then {
    $0.text = "별점."
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
  }
  private let expressLabel = UILabel().then {
    $0.text = "향에 대한 기록."
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
  }
  private let keywordLabel = UILabel().then {
    $0.text = "향을 맡았을 때 어떤 단어가 떠오르나요?"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
  }
  private let longevityLabel = UILabel().then {
    $0.text = "향이 얼마나 지속되나요?"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
  }
  private let sillageLabel = UILabel().then {
    $0.text = "잔향의 느낌이 어떤가요?"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
  }
  private let seasonalLabel = UILabel().then {
    $0.text = "어느 계절에 뿌리고 싶나요?"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
  }
  private let genderLabel = UILabel().then {
    $0.text = "누가 뿌리면 좋을까요?"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
  }
  private let shareLabel = UILabel().then {
    $0.text = "다른 분들과 향에 대한 기록을 공유해보세요.\n나의 시향 노트를 공개 하시겠습니까?"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
    $0.numberOfLines = 2
  }
  
  // StackView
  private lazy var detailStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.addArrangedSubview(self.detailLabel)
    $0.addArrangedSubview(self.arrowRightView)
  }
  
  // Star
  private let starView = CosmosView().then {
    $0.rating = 0
    $0.settings.starSize = 24
    $0.settings.fillMode = .half
    $0.settings.emptyImage = .starUnfilled
    $0.settings.filledImage = .starFilled
    $0.settings.starMargin = 4
  }
  
  // TextField
  private let noteTextField = UITextView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.grayCd.cgColor
    $0.textContainerInset = .init(top: 18, left: 18, bottom: 18, right: 18)
  }
  
  // Dotted Line
  private lazy var longevityUnderlineView = UIView().then {
    $0.backgroundColor = .grayCd
  }
  
  private lazy var genderUnderlineView = UIView().then {
    $0.backgroundColor = .grayCd
  }
  
  private lazy var sillageUnderlineView = UIView().then {
    $0.backgroundColor = .grayCd
  }
  
  // Button
  private let keywordAddButton = UIButton().then {
    $0.setTitle("추가", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.blackText.cgColor
  }
  
  private let doneButton = DoneButton(title: "기록 완료")
  private let deleteButton = DoneButton(title: "삭제").then {
    $0.setBackgroundColor(color: .darkGray7d)
  }
  private let updateButton = DoneButton(title: "수정 완료")


  // CollectionView
  private let keywordCollectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewKeywordLayout).then {
    $0.backgroundColor = .lightGray
    $0.register(SurveyKeywordCollectionViewCell.self)
  }
  private let longevityCollectionView =  UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewLongevityLayout).then {
    $0.backgroundColor = .clear
    $0.register(ReviewLongevityCell.self)
  }
  private let sillageCollectionView =  UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewLongevityLayout).then {
    $0.backgroundColor = .clear
    $0.register(ReviewGenderCell.self)
  }
  private let seasonalCollectionView =  DynamicCollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewSeasonalLayout).then {
    $0.backgroundColor = .clear
    $0.register(ReviewSeasonalCell.self)
  }
  private let genderCollectionView =  UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewLongevityLayout).then {
    $0.backgroundColor = .clear
    $0.register(ReviewGenderCell.self)
  }
  
  private let scrollView = UIScrollView()
  private let containerView = UIView()
  private let imageContainerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.bgTabBar.cgColor
  }
  private let shareView = UIView()
  private let shareCheckView = UIImageView().then {
    $0.image = .checkWhite
  }
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  private let arrowRightView = UIImageView().then {
    $0.image = .arrowRight
  }
  
  private let dividerViewUnderRecord = UIView().then { $0.backgroundColor = .blackText }
  private let dividerViewUnderScore = UIView().then { $0.backgroundColor = .blackText }
  private let dividerViewUnderExpress = UIView().then { $0.backgroundColor = .blackText }
  private let dividerViewUnderKeyword = UIView().then { $0.backgroundColor = .blackText }
  private let dividerViewUnderSillage = UIView().then { $0.backgroundColor = .blackText }
  private let dividerViewUnderGender = UIView().then { $0.backgroundColor = .blackText }
 
  
  // MARK: - Vars & Lets
  var viewModel: PerfumeReviewViewModel?
  let disposeBag = DisposeBag()
  private var collectionViewHeight: CGFloat = 0
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.keywordCollectionView.layoutIfNeeded()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  
  // MARK: - Configure UI
  private func configureUI() {
    self.configureNavigation()
    self.keywordCollectionView.delegate = self
    self.view.backgroundColor = .lightGray
    
    self.view.addSubview(self.scrollView)
    self.view.addSubview(self.doneButton)
    self.scrollView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalTo(self.doneButton.snp.top)
      $0.left.right.equalToSuperview()
    }
    
    self.scrollView.addSubview(self.containerView)
    self.containerView.snp.makeConstraints {
      $0.centerX.top.bottom.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    self.containerView.addSubview(self.imageContainerView)
    self.imageContainerView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(24)
      $0.size.equalTo(156)
    }
    
    self.imageContainerView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(133)
    }
    
    self.containerView.addSubview(self.detailStackView)
    self.detailStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.imageContainerView.snp.bottom).offset(12)
    }
    
    self.containerView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.top.equalTo(self.detailStackView.snp.bottom).offset(24)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom).offset(7)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.recordLabel)
    self.recordLabel.snp.makeConstraints {
      $0.top.equalTo(self.nameLabel.snp.bottom).offset(20)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.dividerViewUnderRecord)
    self.dividerViewUnderRecord.snp.makeConstraints {
      $0.top.equalTo(self.recordLabel.snp.bottom).offset(12)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(2)
    }
    
    self.containerView.addSubview(self.scoreLabel)
    self.scoreLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderRecord.snp.bottom).offset(28)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.starView)
    self.starView.snp.makeConstraints {
      $0.centerY.equalTo(self.scoreLabel)
      $0.right.equalToSuperview().offset(-16)
    }
    
    self.containerView.addSubview(self.dividerViewUnderScore)
    self.dividerViewUnderScore.snp.makeConstraints {
      $0.top.equalTo(self.scoreLabel.snp.bottom).offset(26)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.expressLabel)
    self.expressLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderScore.snp.bottom).offset(24)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.noteTextField)
    self.noteTextField.snp.makeConstraints {
      $0.top.equalTo(self.expressLabel.snp.bottom).offset(16)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(100)
    }
    
    self.containerView.addSubview(self.dividerViewUnderExpress)
    self.dividerViewUnderExpress.snp.makeConstraints {
      $0.top.equalTo(self.noteTextField.snp.bottom).offset(24)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.keywordLabel)
    self.keywordLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderExpress.snp.bottom).offset(24)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.keywordAddButton)
    self.keywordAddButton.snp.makeConstraints {
      $0.top.equalTo(self.keywordLabel.snp.bottom).offset(14)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(50)
    }
    
    self.keywordCollectionView.translatesAutoresizingMaskIntoConstraints = false
    self.containerView.addSubview(self.keywordCollectionView)
    self.keywordCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.keywordAddButton.snp.bottom).offset(12)
      $0.left.right.equalToSuperview().inset(16)
    }
    
    self.containerView.addSubview(self.dividerViewUnderKeyword)
    self.dividerViewUnderKeyword.snp.makeConstraints {
      $0.top.equalTo(self.keywordCollectionView.snp.bottom).offset(24)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.longevityLabel)
    self.longevityLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderKeyword.snp.bottom).offset(24)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.longevityUnderlineView)
    self.longevityUnderlineView.snp.makeConstraints {
      $0.top.equalTo(self.longevityLabel.snp.bottom).offset(23)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.longevityCollectionView)
    self.longevityCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.longevityUnderlineView).offset(-13.5)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(100)
    }
    
    self.containerView.addSubview(self.sillageLabel)
    self.sillageLabel.snp.makeConstraints {
      $0.top.equalTo(self.longevityUnderlineView.snp.bottom).offset(112)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.sillageUnderlineView)
    self.sillageUnderlineView.snp.makeConstraints {
      $0.top.equalTo(self.sillageLabel.snp.bottom).offset(24)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.sillageCollectionView)
    self.sillageCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.sillageUnderlineView).offset(-13.5)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(70)
    }
    
    self.containerView.addSubview(self.dividerViewUnderSillage)
    self.dividerViewUnderSillage.snp.makeConstraints {
      $0.top.equalTo(self.sillageUnderlineView.snp.bottom).offset(60)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.seasonalLabel)
    self.seasonalLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderSillage.snp.bottom).offset(24)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.seasonalCollectionView)
    self.seasonalCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.seasonalLabel.snp.bottom).offset(16)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(124)
    }
    
    self.containerView.addSubview(self.genderLabel)
    self.genderLabel.snp.makeConstraints {
      $0.top.equalTo(self.seasonalCollectionView.snp.bottom).offset(36)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.genderUnderlineView)
    self.genderUnderlineView.snp.makeConstraints {
      $0.top.equalTo(self.genderLabel.snp.bottom).offset(24)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.genderCollectionView)
    self.genderCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.genderUnderlineView).offset(-13.5)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(70)
    }
    
    self.containerView.addSubview(self.dividerViewUnderGender)
    self.dividerViewUnderGender.snp.makeConstraints {
      $0.top.equalTo(self.genderUnderlineView.snp.bottom).offset(63)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(2)
    }
    
    self.containerView.addSubview(self.shareLabel)
    self.shareLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderGender.snp.bottom).offset(24)
      $0.bottom.equalToSuperview().offset(-45)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.shareView)
    self.shareView.snp.makeConstraints {
      $0.centerY.equalTo(self.shareLabel)
      $0.right.equalToSuperview().offset(-16)
      $0.size.equalTo(22)
    }
    
    self.shareView.addSubview(self.shareCheckView)
    self.shareCheckView.snp.makeConstraints {
      $0.center.equalTo(self.shareView)
    }
    
    self.doneButton.snp.makeConstraints {
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(86)
    }
    self.doneButton.isHidden = true
    
    self.view.addSubview(self.deleteButton)
    self.deleteButton.snp.makeConstraints {
      $0.bottom.left.equalToSuperview()
      $0.width.equalTo(100)
      $0.height.equalTo(86)
    }
    self.deleteButton.isHidden = true
    
    self.view.addSubview(self.updateButton)
    self.updateButton.snp.makeConstraints {
      $0.left.equalTo(self.deleteButton.snp.right)
      $0.bottom.right.equalToSuperview()
      $0.height.equalTo(86)
    }
    self.updateButton.isHidden = true
  }
  
  private func configureNavigation() {
    self.setBackButton()
    self.setNavigationTitle(title: "시향 노트")
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    let starViewUpdated = PublishRelay<Double>()
    starView.didFinishTouchingCosmos = { rating in
      starViewUpdated.accept(rating)
    }

    let input = PerfumeReviewViewModel.Input(
      imageContainerDidTapEvent: imageContainerView.rx.tapGesture().when(.recognized).asObservable(),
      starViewDidUpdateEvent: starViewUpdated,
      noteTextFieldDidEditEvent: self.noteTextField.rx.text.orEmpty.asObservable(),
      keywordAddButtonDidTapEvent: self.keywordAddButton.rx.tap.asObservable(),
      longevityCellDidTapEvent: self.longevityCollectionView.rx.itemSelected.map {$0.item}.asObservable(),
      sillageCellDidTapEvent: self.sillageCollectionView.rx.itemSelected.map {$0.item}.asObservable(),
      seasonalCellDidTapEvent: self.seasonalCollectionView.rx.itemSelected.map {$0.item}.asObservable(),
      genderCellDidTapEvent: self.genderCollectionView.rx.itemSelected.map {$0.item}.asObservable(),
      shareButtonDidTapEvent: self.shareView.rx.tapGesture().when(.recognized).map { _ in},
      doneButtonDidTapEvent: self.doneButton.rx.tap.asObservable(),
      deleteButtonDidTapEvent: self.deleteButton.rx.tap.asObservable(),
      updateButtonDidTapEvent: self.updateButton.rx.tap.asObservable()
    )
    let output = viewModel?.transform(from: input, disposeBag: self.disposeBag)
    self.bindView(output: output)
    self.bindKeyword(output: output)
    self.bindLongevity(output: output)
    self.bindSillage(output: output)
    self.bindSeasonal(output: output)
    self.bindGender(output: output)
    self.bindShareButton(output: output)
    self.bindDoneButton(output: output)
    self.bindUpdateButton(output: output)
  }
  
  private func bindView(output: PerfumeReviewViewModel.Output?) {
    output?.reviewDetail
      .asDriver()
      .drive(onNext: { [weak self] reviewDetail in
        self?.updateUI(reviewDetail: reviewDetail)
      })
      .disposed(by: self.disposeBag)
    
    output?.perfumeDetail
      .asDriver()
      .drive(onNext: { [weak self] perfumeDetail in
        self?.updateUI(perfumeDetail: perfumeDetail)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindKeyword(output: PerfumeReviewViewModel.Output?) {
//    rx.methodInvoked(#selector(viewWillLayoutSubviews))
//      .subscribe(onNext: { [weak self] _ in
//        self?.updateViewHeight()
//      })
//      .disposed(by: self.disposeBag)
    
    output?.keywords
      .observe(on: MainScheduler.instance)
      .bind(to: self.keywordCollectionView.rx.items(cellIdentifier: "SurveyKeywordCollectionViewCell", cellType: SurveyKeywordCollectionViewCell.self)) { _, keyword, cell in
      cell.updateUI(keyword: keyword)
    }
    .disposed(by: self.disposeBag)
  }
  
  private func bindLongevity(output: PerfumeReviewViewModel.Output?) {
    output?.longevities
      .bind(to: self.longevityCollectionView.rx.items(cellIdentifier: "ReviewLongevityCell", cellType: ReviewLongevityCell.self)) { _, longevity, cell in
      cell.updateUI(longevity: longevity)
    }
    .disposed(by: self.disposeBag)
  }
 
  private func bindSillage(output: PerfumeReviewViewModel.Output?) {
    output?.sillages
      .bind(to: self.sillageCollectionView.rx.items(cellIdentifier: "ReviewGenderCell", cellType: ReviewGenderCell.self)) { _, sillage, cell in
      cell.updateUI(sillage: sillage)
    }
    .disposed(by: self.disposeBag)
  }
  
  private func bindSeasonal(output: PerfumeReviewViewModel.Output?) {
    output?.seasonals
      .bind(to: self.seasonalCollectionView.rx.items(cellIdentifier: "ReviewSeasonalCell", cellType: ReviewSeasonalCell.self)) { _, seasonal, cell in
      cell.updateUI(seasonal: seasonal)
    }
    .disposed(by: self.disposeBag)
  }
  
  private func bindGender(output: PerfumeReviewViewModel.Output?) {
    output?.genders
      .bind(to: self.genderCollectionView.rx.items(cellIdentifier: "ReviewGenderCell", cellType: ReviewGenderCell.self)) { _, gender, cell in
      cell.updateUI(gender: gender)
    }
    .disposed(by: self.disposeBag)
  }
  
  private func bindShareButton(output: PerfumeReviewViewModel.Output?) {
    output?.isShareButtonSelected
      .asDriver()
      .drive(onNext: { [weak self] isSelected in
        self?.shareView.backgroundColor = isSelected ? .pointBeige : .bgTabBar
      })
      .disposed(by: self.disposeBag)
    
    output?.showToast
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        self?.view.makeToast("입력 칸을 모두 작성해야 공개가 가능합니다.")
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindDoneButton(output: PerfumeReviewViewModel.Output?) {
    output?.canDone
      .asDriver()
      .drive(onNext: { [weak self] canDone in
        self?.doneButton.backgroundColor = canDone ? .blackText : .grayCd
        self?.doneButton.isEnabled = canDone ? true : false
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindUpdateButton(output: PerfumeReviewViewModel.Output?) {
    output?.canUpdate
      .asDriver()
      .drive(onNext: { [weak self] canUpdate in
        Log(canUpdate)
        self?.updateButton.backgroundColor = canUpdate ? .blackText : .grayCd
        self?.updateButton.isEnabled = canUpdate ? true : false
      })
      .disposed(by: self.disposeBag)
  }
  
  private func updateUI(perfumeDetail: PerfumeDetail?) {
    guard let perfumeDetail = perfumeDetail else { return }
    self.imageView.load(url: perfumeDetail.imageUrls[0])
    self.brandLabel.text = perfumeDetail.brandName
    self.nameLabel.text = perfumeDetail.name
    self.doneButton.isHidden = false
  }
  
  private func updateUI(reviewDetail: ReviewDetail?) {
    guard let reviewDetail = reviewDetail, let perfume = reviewDetail.perfume, let brand = reviewDetail.brand else { return }
    self.imageView.load(url: perfume.imageUrl)
    self.brandLabel.text = brand.name
    self.nameLabel.text = perfume.name
    self.starView.rating = reviewDetail.score
    self.noteTextField.text = reviewDetail.content
    self.deleteButton.isHidden = false
    self.updateButton.isHidden = false
    self.shareView.backgroundColor = reviewDetail.access ? .pointBeige : .bgTabBar
  }
//
//  private func updateViewHeight() {
//    let height = keywordCollectionView.contentSize.height
//    guard height != collectionViewHeight else { return }
//    self.collectionViewHeight = height
//    self.keywordCollectionView.snp.updateConstraints {
//      $0.height.equalTo(height)
//    }
//  }
  
//  private func dottedLineLayer() -> CAShapeLayer {
//    let borderLayer = CAShapeLayer()
//    borderLayer.strokeColor = UIColor.black.cgColor
//    borderLayer.lineDashPattern = [2, 2]
//    let path = CGMutablePath()
//        path.addLines(between: [CGPoint(x: 0, y: 0),
//                                CGPoint(x: self.view.bounds.width - 36, y: 0)])
//
//    borderLayer.path = path
//    return borderLayer
//  }
}

extension PerfumeReviewViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let cell = cell as? SurveyKeywordCollectionViewCell else { return }
    if cell.frame.size.width == 100 {
      DispatchQueue.main.async {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
      }
    }
  }
}

