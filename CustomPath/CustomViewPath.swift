//
//  CustomViewPath.swift
//  CustomPath
//
//  Created by MinhHieu on 06/02/2025.
//

import Foundation
import UIKit

class CustomViewPath: UIView {
    var cornerRadius: CGFloat = 30.0
    var dipDepth: CGFloat = 50.0 // Độ sâu lõm hoặc chiều cao lồi
    var isConvex: Bool = false // Lồi (true) hay lõm (false)

    override func draw(_ rect: CGRect) {
        // Tạo đường path
        let path = UIBezierPath()

        let width = rect.width
        let height = rect.height

        // Điểm bắt đầu (góc trên bên trái)
        path.move(to: CGPoint(x: 0, y: cornerRadius))

        // Bo tròn góc trên bên trái
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi,
                    endAngle: .pi * 1.5,
                    clockwise: true)

        // Đường ngang phía trên đến phần lồi/lõm
        path.addLine(to: CGPoint(x: width / 2 - cornerRadius - 10, y: 0))

        // Tạo lồi hoặc lõm ở giữa
        let dipControlY: CGFloat = isConvex ? -cornerRadius : cornerRadius
        
        path.addQuadCurve(to: CGPoint(x: width / 2 + cornerRadius + 10, y: 0),
                          controlPoint: CGPoint(x: width / 2, y: dipControlY + 40))

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

        // Vẽ hình
        UIColor.red.setFill()
        
        path.fill()
    }
}
