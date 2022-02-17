//
//  ViewController.swift
//  SpaceySpaceChallenge
//
//  Created by Horacio Lopez on 2/17/22.
//

import UIKit

class ViewController: UIViewController {
    
    // UI Vars
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = true
        cv.backgroundColor = .red
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

