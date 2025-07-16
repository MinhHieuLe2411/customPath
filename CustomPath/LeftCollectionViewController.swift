//
//  LeftCollectionViewController.swift
//  CustomPath
//
//  Created by MinhHieu on 11/02/2025.
//

import UIKit

class LeftCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    lazy var collectionView: UICollectionView = {
        let layout = SnappyFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        let cv = UICollectionView(frame: .zero)
        cv.collectionViewLayout = layout
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = false // Chúng ta đã xử lý paging thủ công
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .black
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .cyan
        return cell
    }
}

