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
    
    private var leftMostView: UIView?
    private var rightMostLoader: UIView?
    
    var items = [1,2,3,4,5]
    var isLoading = false
    var hasMoreDataToLoad = false
    private var isObservingKeyPath: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
    }
    
}

extension HorizontalPaginationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 30,
                      height: collectionView.bounds.height)
    }
    
}

extension HorizontalPaginationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alwaysBounceHorizontal = true
        self.addScrollViewOffsetObserver()
        self.load()
    }
    
    func addScrollViewOffsetObserver() {
        if self.isObservingKeyPath { return }
        self.collectionView.addObserver(
            self,
            forKeyPath: "contentOffset",
            options: [.new],
            context: nil
        )
        self.isObservingKeyPath = true
    }
    
    func removeScrollViewOffsetObserver() {
        if self.isObservingKeyPath {
            self.collectionView.removeObserver(self,
                                               forKeyPath: "contentOffset")
        }
        self.isObservingKeyPath = false
    }
    
    override public func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard let object = object as? UIScrollView,
            let keyPath = keyPath,
            let newValue = change?[.newKey] as? CGPoint,
            object == self.collectionView, keyPath == "contentOffset" else { return }
        self.setContentOffSet(newValue)
    }
    
    private func setContentOffSet(_ offset: CGPoint) {
        let offsetX = offset.x
        if offsetX < -100 && !self.isLoading {
            self.isLoading = true
            self.addLeftMostControl()
            self.refreshAll { success in
                print("refreshAll CB:", success)
                self.isLoading = false
                self.removeLeftLoader()
            }
            return
        }
        
        let diffX = self.collectionView.contentSize.width - self.collectionView.bounds.size.width
        print(diffX)
        if offsetX > (diffX + 130) && !self.isLoading {
            self.isLoading = true
            self.addRightMostControl()
            self.loadMore { success in
                print("loadmore CB:", success)
                self.isLoading = false
                self.removeRightLoader()
            }
        }
    }
    
}

// LEFT LOADER
extension HorizontalPaginationViewController {
    
    private func addLeftMostControl() {
        let view = UIView()
        view.backgroundColor = .yellow
        view.frame.origin = CGPoint(x: -60, y: 0)
        view.frame.size = CGSize(width: 60,
                                 height: self.collectionView.bounds.height)
        let activity = UIActivityIndicatorView(style: .gray)
        activity.frame = view.bounds
        activity.startAnimating()
        view.addSubview(activity)
        self.collectionView.contentInset.left = view.frame.width
        self.leftMostView = view
        self.collectionView.addSubview(view)
    }
    
    func removeLeftLoader() {
        self.leftMostView?.removeFromSuperview()
        self.collectionView.contentInset.left = 0
        self.collectionView.setContentOffset(.zero, animated: true)
    }
}

//RIGHT LOADER
extension HorizontalPaginationViewController {
    
        private func addRightMostControl() {
            let view = UIView()
            view.backgroundColor = .yellow
            view.frame.origin = CGPoint(x: self.collectionView.contentSize.width,
                                        y: 0)
            view.frame.size = CGSize(width: 60,
                                     height: self.collectionView.bounds.height)
            let activity = UIActivityIndicatorView(style: .gray)
            activity.frame = view.bounds
            activity.startAnimating()
            view.addSubview(activity)
            self.collectionView.contentInset.right = view.frame.width
            self.rightMostLoader = view
            self.collectionView.addSubview(view)
        }
    
    func removeRightLoader() {
        self.rightMostLoader?.removeFromSuperview()
    }
}

extension HorizontalPaginationViewController {
    
    private func handleDataLoad(items: [Int]) {
        self.items.removeAll()
        self.items = items
        self.collectionView.reloadData()
    }
    
    private func handleMoreDataLoad(items: [Int]) {
        self.items.append(contentsOf: items)
        self.collectionView.reloadData()
    }
    
    func load() {
        print("load called")
        self.refreshAll { _ in
            
        }
    }
    
    func refreshAll(completion: @escaping (Bool) -> Void) {
        print("refreshAll called")
        delay(3) {
            self.handleDataLoad(items: [1,2,3,4,5])
            completion(true)
        }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        print("loadMore called")
        delay(3) {
            self.handleMoreDataLoad(items: [1,2,3,4,5])
            completion(true)
        }
    }
}
