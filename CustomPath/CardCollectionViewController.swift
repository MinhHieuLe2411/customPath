//
//  CardCollectionViewController.swift
//  CustomPath
//
//  Created by MinhHieu on 11/02/2025.
//

import UIKit

class CardCollectionViewController: UIViewController {
    
    @IBOutlet weak var cvDemo: UICollectionView!
    
    var stackedViewFlowLayout: StackedViewFlowLayout?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cvDemo.register(UINib(nibName: "DemoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCollectionViewCell")
        stackedViewFlowLayout = StackedViewFlowLayout(itemWidth: (3*cvDemo.frame.width)/4, numVisibleItems: 5, listCount: 10, cvWidth: cvDemo.frame.width)
        cvDemo.collectionViewLayout = stackedViewFlowLayout!
        
    }

}

extension CardCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stackedViewFlowLayout!.getTotalCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCollectionViewCell", for: indexPath) as? DemoCollectionViewCell else { return DemoCollectionViewCell() }
        cell.tag = indexPath.row
        return stackedViewFlowLayout!.setUpCell(cell: cell)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stackedViewFlowLayout?.updateScrollView()
    }
}
