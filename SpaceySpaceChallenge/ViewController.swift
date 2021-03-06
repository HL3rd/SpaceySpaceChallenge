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
        cv.backgroundColor = .white
        return cv
    }()
    
    // Data vars
    var launchesLoading = false
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
        
        guard !launchesLoading else { return }
        
        launchesLoading = true
        
        Network.shared.apollo.fetch(query: PastLaunchesListQuery(limit: 10, offset: self.offset)) { result in
            
            guard let data = try? result.get().data?.launchesPast else {
                print("Error with PastLaunchesListQuery: \(result)")
                self.launchesLoading = false
                return
            }
            
            self.launchesData.append(contentsOf: data)
            self.offset += 10
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.launchesLoading = false
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
        
        let launch = launchesData[indexPath.item]
        pastLaunchCell?.initializeLaunchCell(launchData: launch)
        
        return pastLaunchCell ?? UICollectionViewCell()
    }
    
    // Tapped a cell to view video
    // TODO: Add buttons and delegates to trigger article reading
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let launch = launchesData[indexPath.item]
        let links = launch?.resultMap["links"] as? [String:Any?]
        let videoStr = links?["video_link"] as? String ?? ""

        guard let url = URL(string: videoStr) else { return }

        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    }
    
    // Prevents premature pagination / many ca;;s
    private func launchesAreLoading() -> Bool {
        return (launchesLoading && launchesData.isEmpty)
    }
    
    // For pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (launchesAreLoading()) { return }
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 10.0
        
        if y > (h + reload_distance) {
            loadPastLaunchesData()
        }
    }
}

