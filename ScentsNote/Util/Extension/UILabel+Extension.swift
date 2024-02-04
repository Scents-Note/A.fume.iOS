//
//  UILabel+Extension.swift
//  ScentsNote
//
//  Created by Soo on 1/7/24.
//

import Foundation
import UIKit

extension UILabel {

//    var lineCount: Int {
//        let text = (self.text ?? "") as NSString
//
//        let maxSize = CGSize(width: frame.size.width,
//                             height: CGFloat(MAXFLOAT))
//        let textHeight = text.boundingRect(with: maxSize,
//                                           options: .usesLineFragmentOrigin,
//                                           attributes: [.font: font as Any],
//                                           context: nil).height
//        let lineHeight = font.lineHeight
//        
//        return Int(ceil(textHeight / lineHeight))
//    }
    
    func countCurrentLines(width: CGFloat) -> Int {
        guard let text = self.text as NSString? else { return 0 }
        guard let font = self.font              else { return 0 }
        
        var attributes = [NSAttributedString.Key: Any]()
        
        // kern을 설정하면 자간 간격이 조정되기 때문에, 크기에 영향을 미칠 수 있습니다.
        if let kernAttribute = self.attributedText?.attributes(at: 0, effectiveRange: nil).first(where: { key, _ in
            return key == .kern
        }) {
            attributes[.kern] = kernAttribute.value
        }
        attributes[.font] = font
        
        // width을 제한한 상태에서 해당 Text의 Height를 구하기 위해 boundingRect 사용
        let labelTextSize = text.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        
        // 총 Height에서 한 줄의 Line Height를 나누면 현재 총 Line 수
        return Int(ceil(labelTextSize.height / font.lineHeight))
    }
 
}
