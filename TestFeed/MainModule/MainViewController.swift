//
//  MainViewController.swift
//  TestFeed
//
//  Created by Клим on 23.07.2021.
//

import UIKit

protocol MainViewProtocol: UIViewController {
    func updateUI()
    func changeLoadingStatus()
    func animateImageView(imageView: UIImageView)
}

class MainViewController: UIViewController {
    @IBOutlet weak var tableFeed: UITableView!
    
    var presenter: MainPresenterProtocol!
    var loadMore = false
    let blackBackgroundView = UIView()
    let zoomImageView = UIImageView()
    let navBarCoverView = UIView()
    var postImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableFeed.delegate = self
        tableFeed.dataSource = self
    }
    
    @objc func zoomOut(){
        if let startingFrame = postImageView.superview?.convert(postImageView.frame, to: nil){
            UIView.animate(withDuration: 0.75) { () -> Void in
                self.zoomImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
            } completion: { (didComplete) -> Void in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.postImageView.alpha = 1
                
            }
            
        }
    }

}

extension MainViewController: MainViewProtocol{
    func animateImageView(imageView: UIImageView) {
        self.postImageView = imageView
        if let startingFrame = imageView.superview?.convert(imageView.frame, to: nil){
            imageView.alpha = 0
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = .black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 94)
            navBarCoverView.backgroundColor = .black
            navBarCoverView.alpha = 0
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            keyWindow?.addSubview(navBarCoverView)
            
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = imageView.image
            zoomImageView.contentMode = .scaleAspectFit
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.75) { () -> Void in
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                
                let y = self.view.frame.height / 2 - height / 2
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                self.blackBackgroundView.alpha = 1
                self.navBarCoverView.alpha = 1
            }
        }
        
    }
    
    func changeLoadingStatus() {
        loadMore = false
    }
    
    func updateUI() {
        tableFeed.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.feedCount()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageId = presenter.checkCellType(index: indexPath.row)
        switch imageId{
        case "":
            var cell = tableView.dequeueReusableCell(withIdentifier: "FeedCellShort") as! FeedShortViewCell
            cell = presenter.prepareCell(cell: cell, index: indexPath.row, imageId: imageId) as! FeedShortViewCell
            return cell
        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedViewCell
            cell = presenter.prepareCell(cell: cell, index: indexPath.row, imageId: imageId) as! FeedViewCell
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height{
            if !loadMore{
                loadMore = true
            presenter.loadData()
            }
        }
    }
    
}
