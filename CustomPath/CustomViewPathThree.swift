//
//  CustomViewPathThree.swift
//  CustomPath
//
//  Created by MinhHieu on 10/02/2025.
//

import Foundation
import UIKit

class CustomViewPathThree: UIView {
    var cornerRadius: CGFloat = 70.0
    var dipDepth: CGFloat = 50.0 // Độ sâu lõm hoặc chiều cao lồi
    
    override func draw(_ rect: CGRect) {
        // Tạo đường path
        let path = UIBezierPath()

        let width = rect.width
        let height = rect.height - 46
        
        let centerWidth = width / 2
        
        // Điểm bắt đầu (góc trên bên trái)
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        
        // Bo tròn góc trên bên trái
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi,
                    endAngle: .pi * 1.5,
                    clockwise: true)

        // Đường ngang phía trên đến phần lồi/lõm
        path.addLine(to: CGPoint(x: width / 2 - height, y: 0))
        
        path.addCurve(to: CGPoint(x: centerWidth, y: -height * 1.2 / 2),
                      controlPoint1: CGPoint(x: centerWidth - cornerRadius - 5, y: 0),
                      controlPoint2: CGPoint(x: centerWidth - cornerRadius - 10, y: -height * 1.2 / 2))
        
        path.addCurve(to: CGPoint(x: centerWidth + height, y: 0),
                      controlPoint1: CGPoint(x: centerWidth + cornerRadius + 10, y: -height * 1.2 / 2),
                      controlPoint2: CGPoint(x: centerWidth + cornerRadius + 5, y: 0))

        // Đường ngang bên phải đến góc trên bên phải
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))

        // Bo tròn góc trên bên phải
        path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi * 1.5,
                    endAngle: 0,
                    clockwise: true)

        // Đường thẳng dọc bên phải
        path.addLine(to: CGPoint(x: width, y: height))

        // Đường ngang phía dưới
        path.addLine(to: CGPoint(x: 0, y: height))

        // Đường thẳng dọc bên trái
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))

        // Đóng đường path
        path.close()
        
        // Dịch chuyển path xuống 50 điểm
        let translation = CGAffineTransform(translationX: 0, y: 46)
        path.apply(translation)

        // Vẽ hình
        UIColor.red.setFill()
        
        path.fill()
    }
}
