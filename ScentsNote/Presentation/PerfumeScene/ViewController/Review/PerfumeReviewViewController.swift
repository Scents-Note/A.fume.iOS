//
//  PerfumeReviewViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Cosmos

final class PerfumeReviewViewController: UIViewController {
  
  // MARK: - UI
  
  // Label
  private let detailLabel = UILabel().then {
    $0.text = "상품 자세히 보기"
    $0.textColor = .darkGray7d
  }
  
  private let brandLabel = UILabel().then {
    $0.textColor = .darkGray7d
  }
  private let nameLabel = UILabel().then {
    $0.textColor = .black1d
  }
  private let recordLabel = UILabel().then {
    $0.text = "향을 오래 기억할 수 있도록 기록해볼까요?"
  }
  private let scoreLabel = UILabel().then {
    $0.text = "별점."
    $0.textColor = .blackText
  }
  private let expressLabel = UILabel().then {
    $0.text = "향을 자유롭게 표현해보세요."
    $0.textColor = .blackText
  }
  private let keywordLabel = UILabel().then {
    $0.text = "향을 맡았을 때 어떤 단어가 떠오르나요?"
    $0.textColor = .blackText
  }
  private let longevityLabel = UILabel().then {
    $0.text = "향이 얼마나 지속되나요?"
    $0.textColor = .blackText
  }
  private let sillageLabel = UILabel().then {
    $0.text = "잔향의 느낌이 어떤가요?"
    $0.textColor = .blackText
  }
  private let seasonalLabel = UILabel().then {
    $0.text = "어느 계절에 뿌리고 싶나요?"
    $0.textColor = .blackText
  }
  private let genderLabel = UILabel().then {
    $0.text = "누가 뿌리면 좋을까요?"
    $0.textColor = .blackText
  }
  private let shareLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.text = "다른 분들과 향에 대한 기록을 공유해보세요.\n나의 시향 노트를 공개 하시겠습니까?"
    $0.textColor = .blackText
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
    $0.settings.starSize = 30
    $0.settings.fillMode = .half
  }
  
  // TextField
  private let noteTextField = UITextView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.grayCd.cgColor
    $0.textContainerInset = .init(top: 18, left: 18, bottom: 18, right: 18)
  }
  
  // Dotted Line
  private lazy var longevityDottedLineView = UIView().then {
    let borderLayer = self.dottedLineLayer()
    $0.layer.addSublayer(borderLayer)
  }
  
  private lazy var genderDottedLineView = UIView().then {
    let borderLayer = self.dottedLineLayer()
    $0.layer.addSublayer(borderLayer)
  }
  
  private lazy var sillageDottedLineView = UIView().then {
    let borderLayer = self.dottedLineLayer()
    $0.layer.addSublayer(borderLayer)
  }
  
  // Button
  private let keywordAddButton = UIButton().then {
    $0.setTitle("추가", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.blackText.cgColor
  }
  
  private let shareButton = UIButton().then {
    $0.setImage(.checkmark, for: .normal)
  }
  
  private let doneButton = DoneButton(title: "기록 완료")
  private let deleteButton = DoneButton(title: "삭제")
  private let updateButton = DoneButton(title: "수정 완료")


  // CollectionView
  private let keywordCollectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.keywordLayout).then {
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
  private let seasonalCollectionView =  UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewSeasonalLayout).then {
    $0.backgroundColor = .clear
    $0.register(ReviewSeasonalCell.self)
  }
  private let genderCollectionView =  UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewLongevityLayout).then {
    $0.backgroundColor = .clear
    $0.register(ReviewGenderCell.self)
  }
  
  private let scrollView = UIScrollView()
  private let containerView = UIView()
  private let imageContainerView = UIView()
  private let imageView = UIImageView().then { $0.contentMode = .scaleAspectFit }
  private let arrowRightView = UIImageView()
  
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
    self.view.backgroundColor = .white
    
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
      $0.top.equalToSuperview()
      $0.width.equalTo(156)
    }
    
    self.imageContainerView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.width.height.equalTo(156)
    }
    
    self.imageContainerView.addSubview(self.detailLabel)
    self.detailLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.imageView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview()
    }
    
    self.containerView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.top.equalTo(self.imageContainerView.snp.bottom).offset(42)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom).offset(8)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.recordLabel)
    self.recordLabel.snp.makeConstraints {
      $0.top.equalTo(self.nameLabel.snp.bottom).offset(10)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.dividerViewUnderRecord)
    self.dividerViewUnderRecord.snp.makeConstraints {
      $0.top.equalTo(self.recordLabel.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(2)
    }
    
    self.containerView.addSubview(self.scoreLabel)
    self.scoreLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderRecord.snp.bottom).offset(10)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.starView)
    self.starView.snp.makeConstraints {
      $0.centerY.equalTo(self.scoreLabel)
      $0.right.equalToSuperview().offset(-18)
    }
    
    self.containerView.addSubview(self.dividerViewUnderScore)
    self.dividerViewUnderScore.snp.makeConstraints {
      $0.top.equalTo(self.scoreLabel.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.expressLabel)
    self.expressLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderScore.snp.bottom).offset(10)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.noteTextField)
    self.noteTextField.snp.makeConstraints {
      $0.top.equalTo(self.expressLabel.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(300)
    }
    
    self.containerView.addSubview(self.dividerViewUnderExpress)
    self.dividerViewUnderExpress.snp.makeConstraints {
      $0.top.equalTo(self.noteTextField.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.keywordLabel)
    self.keywordLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderExpress.snp.bottom).offset(10)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.keywordAddButton)
    self.keywordAddButton.snp.makeConstraints {
      $0.top.equalTo(self.keywordLabel.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(50)
    }
    
    self.keywordCollectionView.translatesAutoresizingMaskIntoConstraints = false
    self.containerView.addSubview(self.keywordCollectionView)
    self.keywordCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.keywordAddButton.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(50)
    }
    
    self.containerView.addSubview(self.dividerViewUnderKeyword)
    self.dividerViewUnderKeyword.snp.makeConstraints {
      $0.top.equalTo(self.keywordCollectionView.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.longevityLabel)
    self.longevityLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderKeyword.snp.bottom).offset(10)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.longevityDottedLineView)
    self.longevityDottedLineView.snp.makeConstraints {
      $0.top.equalTo(self.longevityLabel.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(10)
    }
    
    self.containerView.addSubview(self.longevityCollectionView)
    self.longevityCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.longevityDottedLineView).offset(-14)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(100)
    }
    
    self.containerView.addSubview(self.sillageLabel)
    self.sillageLabel.snp.makeConstraints {
      $0.top.equalTo(self.longevityCollectionView.snp.bottom).offset(10)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.sillageDottedLineView)
    self.sillageDottedLineView.snp.makeConstraints {
      $0.top.equalTo(self.sillageLabel.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(10)
    }
    
    self.containerView.addSubview(self.sillageCollectionView)
    self.sillageCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.sillageDottedLineView).offset(-14)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(70)
    }
    
    self.containerView.addSubview(self.dividerViewUnderSillage)
    self.dividerViewUnderSillage.snp.makeConstraints {
      $0.top.equalTo(self.sillageCollectionView.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(1)
    }
    
    self.containerView.addSubview(self.seasonalLabel)
    self.seasonalLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderSillage.snp.bottom).offset(10)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.seasonalCollectionView)
    self.seasonalCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.seasonalLabel).offset(10)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(200)
    }
    
    self.containerView.addSubview(self.genderLabel)
    self.genderLabel.snp.makeConstraints {
      $0.top.equalTo(self.seasonalCollectionView.snp.bottom).offset(10)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.genderDottedLineView)
    self.genderDottedLineView.snp.makeConstraints {
      $0.top.equalTo(self.genderLabel.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(10)
    }
    
    self.containerView.addSubview(self.genderCollectionView)
    self.genderCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.genderDottedLineView).offset(-14)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(70)
    }
    
    self.containerView.addSubview(self.dividerViewUnderGender)
    self.dividerViewUnderGender.snp.makeConstraints {
      $0.top.equalTo(self.genderCollectionView.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(2)
    }
    
    self.containerView.addSubview(self.shareLabel)
    self.shareLabel.snp.makeConstraints {
      $0.top.equalTo(self.dividerViewUnderGender.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().offset(-45)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.containerView.addSubview(self.shareButton)
    self.shareButton.snp.makeConstraints {
      $0.centerY.equalTo(self.shareLabel)
      $0.right.equalToSuperview().offset(-19)
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
    self.setNavigationTitle(title: "시향 노트 쓰기")
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
      shareButtonDidTapEvent: self.shareButton.rx.tap.asObservable(),
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
    rx.methodInvoked(#selector(viewWillLayoutSubviews))
      .subscribe(onNext: { [weak self] _ in
        self?.updateViewHeight()
      })
      .disposed(by: self.disposeBag)
    
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
        self?.shareButton.setImage(isSelected ? .checkmark : .btnNext, for: .normal)
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
    self.shareButton.setImage(reviewDetail.access ? .checkmark : nil, for: .normal)
  }
  
  private func updateViewHeight() {
    let height = keywordCollectionView.contentSize.height
    guard height != collectionViewHeight else { return }
    self.collectionViewHeight = height
    self.keywordCollectionView.snp.updateConstraints {
      $0.height.equalTo(height)
    }
  }
  
  private func dottedLineLayer() -> CAShapeLayer {
    let borderLayer = CAShapeLayer()
    borderLayer.strokeColor = UIColor.black.cgColor
    borderLayer.lineDashPattern = [2, 2]
    let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.view.bounds.width - 36, y: 0)])

    borderLayer.path = path
    return borderLayer
  }
}
