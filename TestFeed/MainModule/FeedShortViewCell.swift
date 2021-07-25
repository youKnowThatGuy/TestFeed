//
//  FeedShortViewCell.swift
//  TestFeed
//
//  Created by Клим on 23.07.2021.
//

import UIKit

protocol FeedBaseProtocol: UITableViewCell{
    var subsiteLogo: UIImageView! { get set }
    var subsiteName: UILabel! { get set }
    var authorNameLabel: UILabel! { get set }
    var dateLabel: UILabel! { get set }
    var titleLabel: UILabel! { get set }
    var commentCountLabel: UILabel! { get set }
    var likesCountLabel: UILabel! { get set }
    var parentController: MainViewProtocol? {get set}
}

class FeedShortViewCell: UITableViewCell, FeedBaseProtocol {
    
    var parentController: MainViewProtocol?
    @IBOutlet weak var subsiteLogo: UIImageView!
    @IBOutlet weak var subsiteName: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
