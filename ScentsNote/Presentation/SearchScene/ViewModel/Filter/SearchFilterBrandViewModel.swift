//
//  SearchFilterBrandViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/23.
//

import RxSwift
import RxRelay

final class SearchFilterBrandViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let brandInitialCellDidTapEvent = PublishRelay<Int>()
    let brandCellDidTapEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let brandInitials = BehaviorRelay<[FilterBrandInitial]>(value: [])
    let brands = BehaviorRelay<[FilterBrand]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private weak var filterDelegate: FilterDelegate?
  private let fetchBrandsForFilterUseCase: FetchBrandsForFilterUseCase
  private let disposeBag = DisposeBag()
  let input = Input()
  let output = Output()
  var brandCategory = 0
  var brandInfos: [FilterBrandInfo] = []
  var brands: [FilterBrand] = []
  
  // MARK: - Life Cycle
  init(filterDelegate: FilterDelegate,
       fetchBrandsForFilterUseCase: FetchBrandsForFilterUseCase) {
    self.filterDelegate = filterDelegate
    self.fetchBrandsForFilterUseCase = fetchBrandsForFilterUseCase
    
    self.transform(input: self.input, output: self.output)
  }
  
  // MARK: - Binding
  func transform(input: Input, output: Output) {
    let brandInitials = PublishRelay<[FilterBrandInitial]>()
    let brandInitialSelected = BehaviorRelay<Int>(value: 1)
    let brandSelected = PublishRelay<Int>()
    
    self.bindInput(input: input,
                   brandInitials: brandInitials,
                   brandInitialSelected: brandInitialSelected,
                   brandSelected: brandSelected)
    
    self.bindOutput(output: output,
                    brandInitials: brandInitials,
                    brandInitialSelected: brandInitialSelected,
                    brandSelected: brandSelected)
    
    self.fetchDatas(brandInitials: brandInitials,
                    brandInitialSelected: brandInitialSelected)
  }
  
  private func bindInput(input: Input,
                         brandInitials: PublishRelay<[FilterBrandInitial]>,
                         brandInitialSelected: BehaviorRelay<Int>,
                         brandSelected: PublishRelay<Int>) {
    
    input.brandInitialCellDidTapEvent
      .bind(to: brandInitialSelected)
      .disposed(by: self.disposeBag)
    
    input.brandCellDidTapEvent
      .subscribe(onNext: { [weak self] idx in
        self?.updateBrandInfo(brandIdx: idx)
        brandSelected.accept(idx)
      })
      .disposed(by: self.disposeBag)
    
    
  }
  
  private func bindOutput(output: Output,
                          brandInitials: PublishRelay<[FilterBrandInitial]>,
                          brandInitialSelected: BehaviorRelay<Int>,
                          brandSelected: PublishRelay<Int>) {
    
    brandInitials
      .bind(to: output.brandInitials)
      .disposed(by: self.disposeBag)
    
    brandInitialSelected
      .subscribe(onNext: { [weak self] initialIdx in
        let brandsUpdated = self?.brandsUpdated(initialIdx: initialIdx) ?? []
        output.brands.accept(brandsUpdated)
      })
      .disposed(by: self.disposeBag)
    
    brandSelected
      .subscribe(onNext: { [weak self] _ in
        let updated = self?.brandInfos[self?.brandCategory ?? 0].brands ?? []
        output.brands.accept(updated)
      })
      .disposed(by: self.disposeBag)
    
    Observable.zip(brandInitialSelected, brandInitialSelected.skip(1))
      .withLatestFrom(brandInitials) { [weak self] initial, initials in
        self?.brandInitialsUpdated(original: initial.0, updated: initial.1, brandInitials: initials) ?? []
      }
      .bind(to: brandInitials)
      .disposed(by: self.disposeBag)
    
  }
  
  private func fetchDatas(brandInitials: PublishRelay<[FilterBrandInitial]>,
                          brandInitialSelected: BehaviorRelay<Int>) {
    
    // TODO: - 같은 Api에서 이니셜를 따로 뽑아 저장하고 싶은데 ViewModel에서 map으로 걸러주는 게 맞는지? 아니면 UseCase에서 다 처리하고 오는게 맞는지?
    self.fetchBrandsForFilterUseCase.execute()
      .subscribe(onNext: { [weak self] brandInfos in
        self?.brandInfos = brandInfos
        let brandInitialsUpdated = brandInfos.map { FilterBrandInitial(text: $0.initial, isSelected: false) }
        brandInitials.accept(brandInitialsUpdated)
        brandInitialSelected.accept(0)
      })
      .disposed(by: self.disposeBag)
  }
  
  // TODO: - 데이터만 저장해야할 때 코드 가독성을 위해 새로 메모리 할당해서 넣어주는게 좋을지? 아니면 그냥 아래처럼 var을 이용해서 넣어주는게 좋을지?
  private func updateBrandInfo(brandIdx: Int) {
    let brand = self.brandInfos[self.brandCategory].brands[brandIdx]
    
    if !brand.isSelected, self.brands.count == 5 {
      return
    }
    
    if brand.isSelected {
      self.brands = self.brands.filter { $0.idx != brand.idx}
    } else {
      self.brands += [self.brandInfos[self.brandCategory].brands[brandIdx]]
    }
    self.brandInfos[self.brandCategory].brands[brandIdx].isSelected = !brand.isSelected
    self.filterDelegate?.updateBrands(brands: self.brands)
  }
  
  private func brandInitialsUpdated(original: Int, updated: Int, brandInitials: [FilterBrandInitial]) -> [FilterBrandInitial] {
    return brandInitials.enumerated().map { idx, initial in
      if idx == original {
        return FilterBrandInitial(text: initial.text, isSelected: false)
      } else if idx == updated, !initial.isSelected {
        return FilterBrandInitial(text: initial.text, isSelected: true)
      }
      return initial
    }
  }
  
  private func brandsUpdated(initialIdx: Int) -> [FilterBrand] {
    for (idx, brandInfo) in self.brandInfos.enumerated() {
      if idx == initialIdx {
        self.brandCategory = initialIdx
        return brandInfo.brands
      }
    }
    return []
  }

}
