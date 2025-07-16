//
//  StackItemView.swift
//  CustomPath
//
//  Created by MinhHieu on 10/02/2025.
//

import Foundation
import UIKit

public extension NSObject {
    
    class func className() -> String {
        let className = (NSStringFromClass(self) as String).components(separatedBy: ".").last! as String
        return className
    }
    
    func className() -> String {
        let className = (NSStringFromClass(self.classForCoder) as String).components(separatedBy: ".").last! as String
        return className
    }
    
}

protocol StackItemViewDelegate: class {
    func handleTap(_ view: StackItemView)
}

class StackItemView: BaseView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var highlightView: UIView!
    
    private let higlightBGColor = UIColor.red
    
    weak var delegate: StackItemViewDelegate?
    
    var isSelected: Bool = false {
        willSet {
            self.updateUI(isSelected: newValue)
        }
    }
    
    var item: Any? {
        didSet {
            self.configure(self.item)
        }
    }
    
    override func commonInit() {
        super.commonInit()
        self.addTapGesture()
        
        highlightView.layer.cornerRadius = 20
    }
    
    private func configure(_ item: Any?) {
        guard let model = item as? BottomStackItem else { return }
        self.titleLabel.text = model.title
        self.imgView.image = UIImage(named: model.image)
        self.isSelected = model.isSelected
    }
    
    private func updateUI(isSelected: Bool) {
        guard let model = item as? BottomStackItem else { return }
        model.isSelected = isSelected
        let options: UIView.AnimationOptions = isSelected ? [.curveEaseIn] : [.curveEaseOut]
        
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.5,
                       options: options,
                       animations: {
            self.titleLabel.text = isSelected ? model.title : ""
            let color = isSelected ? self.higlightBGColor : .white
            self.highlightView.backgroundColor = color
            (self.superview as? UIStackView)?.layoutIfNeeded()
        }, completion: nil)
    }
    
}

extension StackItemView {
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleGesture(_ sender: UITapGestureRecognizer) {
        self.delegate?.handleTap(self)
//        print("123")
    }
    
}
