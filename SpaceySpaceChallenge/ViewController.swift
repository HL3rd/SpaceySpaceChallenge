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
    
    // Data vars
    var offset: Int = 0
    var launchesData: [PastLaunchesListQuery.Data.LaunchesPast?] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
        loadPastLaunchesData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LaunchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.center = view.center
        collectionView.frame = view.frame
    }

}

// Queries extension, TODO: Refactor
extension ViewController {
    
    private func loadPastLaunchesData() {
                
        Network.shared.apollo.fetch(query: PastLaunchesListQuery(limit: 10, offset: self.offset)) { result in
            
            guard let data = try? result.get().data?.launchesPast else {
                print("Error with PastLaunchesListQuery: \(result)")
                return
            }
            
            self.launchesData.append(contentsOf: data)
            self.offset += 10
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
}


// CollectionView extensions, TODO: Refactor
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    // Method that sets size for the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: self.view.frame.width, height: 150)
        return size
    }
    
    // Method that states how many cells to generate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return launchesData.count
    }
    
    // Method that sets up photo collectionViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let pastLaunchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LaunchCollectionViewCell
        
        return pastLaunchCell ?? UICollectionViewCell()
    }
    
}

