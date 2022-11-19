//
//  SeasonalPieChartView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/19.
//

import UIKit
import SnapKit

struct SeasonalInfo {
  var season: String
  var percent: CGFloat
}

class SeasonalPieChartView: UIView {
  
  func drawPieChart(degrees: [CGFloat]) {
    
    self.drawColor(degrees: degrees)
    self.drawLabel(degrees: degrees)
    
    //x degree = x * π / 180 radian
    
    
    
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
                  radius: 100,
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


    degrees.enumerated().forEach { idx, degree in
      
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
}
