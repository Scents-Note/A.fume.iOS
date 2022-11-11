//
//  Rx.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/10.
//

import RxDataSources
import RxSwift

class RxCollectionViewSectionedNonAnimatedDataSource<Section: AnimatableSectionModelType>: RxCollectionViewSectionedAnimatedDataSource<Section> {
  override func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        UIView.performWithoutAnimation {
            super.collectionView(collectionView, observedEvent: observedEvent)
        }
    }
}
