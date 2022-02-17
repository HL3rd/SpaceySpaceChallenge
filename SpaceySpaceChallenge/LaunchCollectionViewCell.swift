//
//  LaunchCollectionViewCell.swift
//  SpaceySpaceChallenge
//
//  Created by Horacio Lopez on 2/17/22.
//

import UIKit
import SDWebImage

class LaunchCollectionViewCell: UICollectionViewCell {
    
    var missionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 15.0)
        label.textColor = .black
        return label
    }()
    
    var launchSiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 15.0)
        label.textColor = .black
        return label
    }()
    
    var patchImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var launchDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 15.0)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        // Set cell UI basics
        backgroundColor = .white
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
        
        layoutCellConstraints()
    }
    
    private func layoutCellConstraints() {
        
        addSubview(thumbnailImageView)
        addSubview(missionLabel)
        addSubview(patchImageView)
        addSubview(launchSiteLabel)
        addSubview(launchDateLabel)
        
        [
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            thumbnailImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: frame.width * 0.20),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: frame.width * 0.20),
            
            patchImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            patchImageView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            patchImageView.widthAnchor.constraint(equalToConstant: 20),
            patchImageView.heightAnchor.constraint(equalToConstant: 20),
            
            missionLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 15),
            missionLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: 10),
            missionLabel.trailingAnchor.constraint(equalTo: patchImageView.leadingAnchor, constant: -10),
            
            launchSiteLabel.topAnchor.constraint(equalTo: missionLabel.bottomAnchor, constant: 10),
            launchSiteLabel.leadingAnchor.constraint(equalTo: missionLabel.leadingAnchor),
            launchSiteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            launchDateLabel.topAnchor.constraint(equalTo: launchSiteLabel.bottomAnchor, constant: 10),
            launchDateLabel.leadingAnchor.constraint(equalTo: launchSiteLabel.leadingAnchor),
            
        ].forEach {
            $0.isActive = true
        }
        
    }
    
    func initializeLaunchCell(launchData: PastLaunchesListQuery.Data.LaunchesPast?) {
        
        let result = launchData?.resultMap
        
        let missionName = (result?["mission_name"] as? String)
        let launchSite = result?["launch_site"] as? [String:Any?]
        let siteName = (launchSite?["site_name_long"] as? String)
        
        let localDateStr = result?["launch_date_local"] as? String ?? "2020-10-24T11:31:00-04:00"
        let launchDate = timeStringToDateString(myDateString: localDateStr)
        
        missionLabel.text = missionName ?? ""
        launchSiteLabel.text = siteName ?? ""
        launchDateLabel.text = launchDate ?? ""
        
        let links = result?["links"] as? [String:Any?]
        let missionUrl = links?["mission_patch_small"] as? String ?? "https://www.spacex.com/static/images/share.jpg"
        
        let patchSize = CGSize(width: 100, height: 100)
        patchImageView.sd_setImage(with: URL(string: missionUrl), placeholderImage: nil, options: [], context: [.imageThumbnailPixelSize : patchSize], progress: nil)
        
        let videoStr = links?["video_link"] as? String ?? ""
        let thumbnailStr = getThumbnailUrl(videoLink: videoStr) ?? "https://www.spacex.com/static/images/share.jpg"
        let thumbnailSize = CGSize(width: 200, height: 200)
        thumbnailImageView.sd_setImage(with: URL(string: thumbnailStr), placeholderImage: nil, options: [], context: [.imageThumbnailPixelSize : thumbnailSize], progress: nil)
        
    }
    
    private func timeStringToDateString(myDateString: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = dateFormatter.date(from: myDateString) else {
            return nil
        }
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let finalDateStr = dateFormatter.string(from: date)
        return finalDateStr
    }
    
    private func getThumbnailUrl(videoLink: String) -> String? {
        
        let splitUrl = videoLink.components(separatedBy: "/")
        guard let id = splitUrl.last else {
            return nil
        }
        let thumbnailStr = "https://img.youtube.com/vi/\(id)/maxresdefault.jpg"
        
        return thumbnailStr
    }
}
