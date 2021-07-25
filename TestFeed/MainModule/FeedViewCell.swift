//
//  FeedViewCell.swift
//  TestFeed
//
//  Created by Клим on 23.07.2021.
//

import UIKit

class FeedViewCell: UITableViewCell, FeedBaseProtocol {
    
    @IBOutlet weak var subsiteLogo: UIImageView!
    @IBOutlet weak var subsiteName: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    var parentController: MainViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap(){
        parentController?.animateImageView(imageView: postImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
