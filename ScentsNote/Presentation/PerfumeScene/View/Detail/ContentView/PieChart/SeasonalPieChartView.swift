//
//  SeasonalPieChartView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/19.
//

import UIKit
import SnapKit

class SeasonalPieChartView: UIView {
  
  func drawPieChart(degrees: [CGFloat]) {
    if isEmpty(degrees: degrees) {
      self.drawEmpty()
    } else {
      self.drawColor(degrees: degrees)
      self.drawLabel(degrees: degrees)
    }
  }
  
  private func drawEmpty() {
    let center = CGPoint(x: self.center.x, y: self.center.y)
    
    let path = UIBezierPath()
    path.move(to: center)
    path.addArc(withCenter: center,
                radius: 75,
                startAngle: 0,
                endAngle: 2 * .pi,
                clockwise: true)
    
    let fillLayer = CAShapeLayer()
    fillLayer.path = path.cgPath
    fillLayer.fillColor = UIColor.grayCd.cgColor
    self.layer.addSublayer(fillLayer)
    
  }
  
  
  private func drawColor(degrees: [CGFloat]) {
    let center = CGPoint(x: self.center.x, y: self.center.y)
    let seasonalColors: [UIColor] = [.SNDarkBeige1, .SNLightBeige1, .SNLightBeige2, .SNDarkBeige2]
    
    let total: CGFloat = 360
    
    var startAngle: CGFloat = (-(.pi) / 2)
    var endAngle: CGFloat = 0.0
    
    degrees.enumerated().forEach { idx, value in
      endAngle = (value / total) * (.pi * 2)
      
      let path = UIBezierPath()
      path.move(to: center)
      path.addArc(withCenter: center,
                  radius: 75,
                  startAngle: startAngle,
                  endAngle: startAngle + endAngle,
                  clockwise: true)
      
      let fillLayer = CAShapeLayer()
      fillLayer.path = path.cgPath
      fillLayer.fillColor = seasonalColors[idx].cgColor
      self.layer.addSublayer(fillLayer)
      
      startAngle += endAngle
    }
    
  }
  
  private func drawLabel(degrees: [CGFloat]) {
    var current: CGFloat = -90
    let seasons: [String] = ["봄", "여름", "가을", "겨울"]
    
    let idx = hasAProperty(degrees: degrees)
    /// 하나의 값만 100 일때
    if idx != -1 {
      let center = self.center

      let label = UILabel()
      label.textColor = .white
      label.textAlignment = .center
      self.addSubview(label)
      label.text = seasons[idx]
      label.snp.makeConstraints {
        $0.centerX.equalToSuperview().offset(center.x - 75)
        $0.centerY.equalToSuperview().offset(center.y - 75)
      }
      return
    }

    degrees.enumerated().forEach { idx, degree in
      if degree == 0 {
        return
      }
      let center = self.center
      let labelCenter = getLabelCenter(current, current + degree)
      
      let label = UILabel()
      label.textColor = .white
      label.textAlignment = .center
      
      self.addSubview(label)
      label.text = seasons[idx]
      label.translatesAutoresizingMaskIntoConstraints = false
      label.snp.makeConstraints {
        $0.centerX.equalToSuperview().offset(labelCenter.x - center.x)
        $0.centerY.equalToSuperview().offset(labelCenter.y - center.y)
      }
      
      current += degree
    }
  }
  
  private func addLabel(from: CGFloat, to: CGFloat) {
    self.layoutIfNeeded()
  }
  
  
  private func getLabelCenter(_ fromDegrees: CGFloat, _ toDegree: CGFloat) -> CGPoint {
    let chartRadius = self.frame.width / 2
    let radius = chartRadius * 5 / 8
    let labelAngle = self.degreeToRadian((toDegree - fromDegrees) / 2 + fromDegrees)
    let path = UIBezierPath(arcCenter: self.center,
                            radius: radius,
                            startAngle: labelAngle,
                            endAngle: labelAngle,
                            clockwise: true)
    path.close()
    return path.currentPoint
  }
  
  func degreeToRadian(_ degree: CGFloat) -> CGFloat {
    return degree * CGFloat.pi / 180.0
  }
  
  func isEmpty(degrees: [CGFloat]) -> Bool {
    for degree in degrees {
      if degree != CGFloat(0) { return false }
    }
    return true
  }
  
  func hasAProperty(degrees: [CGFloat]) -> Int {
    var cnt = 0
    var idx = 0
    for i in 0..<4 {
      if degrees[i] != CGFloat(0) {
        cnt += 1
        idx = i
      }
    }
    if cnt == 1 {
      return idx
    }
    return -1
  }
}
