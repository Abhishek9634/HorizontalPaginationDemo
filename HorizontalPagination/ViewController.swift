//
//  HorizontalPaginationViewController.swift
//  HorizontalPagination
//
//  Created by Abhishek Thapliyal on 15/07/20.
//  Copyright © 2020 Abhishek Thapliyal. All rights reserved.
//

import UIKit

public func delay(_ delay: Double, closure: @escaping () -> Void) {
    let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(
        deadline: deadline,
        execute: closure
    )
}

class HorizontalPaginationViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [1,2,3,4,5]
    
    private lazy var paginationManager: HorizontalPaginationManager = {
        let manager = HorizontalPaginationManager(scrollView: self.collectionView)
        manager.delegate = self
        return manager
    }()
    
    private var isDragging: Bool {
        return self.collectionView.isDragging
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupPagination()
        self.fetchItems()
    }
    
}

extension HorizontalPaginationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alwaysBounceHorizontal = true
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HorizontalCollectionCell",
            for: indexPath
        ) as! HorizontalCollectionCell
        cell.update(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                       height: collectionView.bounds.height)
     }
    
}

extension HorizontalPaginationViewController: HorizontalPaginationManagerDelegate {
    
    private func setupPagination() {
        self.paginationManager.refreshViewColor = .clear
        self.paginationManager.loaderColor = .white
    }
    
    private func fetchItems() {
        self.paginationManager.initialLoad()
    }
    
    func refreshAll(completion: @escaping (Bool) -> Void) {
        delay(2.0) {
            self.items = [1, 2, 3, 4, 5]
            self.collectionView.reloadData()
            completion(true)
        }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        delay(2.0) {
            self.items.append(contentsOf: [6, 7, 8, 9, 10])
            self.collectionView.reloadData()
            completion(true)
        }
    }
    
}
