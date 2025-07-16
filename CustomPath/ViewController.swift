//
//  ViewController.swift
//  CustomPath
//
//  Created by MinhHieu on 06/02/2025.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var bottomStack: UIStackView!

    var currentIndex = 0
    
    lazy var tabs: [StackItemView] = {
        var items = [StackItemView]()
        for _ in 0..<5 {
            items.append(StackItemView())
        }
        return items
    }()

    lazy var tabModels: [BottomStackItem] = {
        [
            BottomStackItem(title: "Home", image: "home"),
            BottomStackItem(title: "Favorites", image: "heart"),
            BottomStackItem(title: "Search", image: "search"),
            BottomStackItem(title: "Profile", image: "user"),
            BottomStackItem(title: "Settings", image: "settings")
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true

//        addCustomPath1()
//        addCustomPath2()
//        addCustomPath3()
//        
        setupTabs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    func setupTabs() {
        for (index, model) in tabModels.enumerated() {
            let tabView = StackItemView()
            model.isSelected = index == 0
            tabView.item = model
            tabView.delegate = self
            bottomStack.addArrangedSubview(tabView)
            tabs = bottomStack.arrangedSubviews.map { i in
                return i as! StackItemView}
            print("\(bottomStack.arrangedSubviews.count )")
        }
    }

    func addCustomPath1() {
        let customShape = CustomViewPath()
        customShape.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 54)
        customShape.backgroundColor = .clear
        customShape.cornerRadius = 30
        customShape.dipDepth = 50
        customShape.isConvex = false // Thay đổi giữa lồi hoặc lõm
        view.addSubview(customShape)
    }

    func addCustomPath2() {
        let customShape = CustomViewPathTwo()
        customShape.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 54)
        customShape.backgroundColor = .clear
        customShape.cornerRadius = 25
        view.addSubview(customShape)
    }

    func addCustomPath3() {
        let customShape = CustomViewPathThree()
        customShape.frame = CGRect(x: 0, y: 300, width: view.frame.width, height: 100)
        customShape.backgroundColor = .blue
        customShape.clipsToBounds = false
        customShape.cornerRadius = 20
        customShape.dipDepth = 30
        view.addSubview(customShape)
    }
    
}

extension ViewController: StackItemViewDelegate {
    func handleTap(_ view: StackItemView) {
        tabs[currentIndex].isSelected = false
        view.isSelected = true
        currentIndex = tabs.firstIndex(where: { $0 === view }) ?? 0
    }
}
