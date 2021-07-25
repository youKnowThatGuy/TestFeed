//
//  ViewController.swift
//  TestFeed
//
//  Created by Клим on 21.07.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var lastId = 0
    var lastSortingValue = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkService.shared.fetchSingleStockData(lastId: "none", lastSortingValue: "none") { (result) in
            switch result{
            case let .failure(error):
                print(error)
            
            case let .success(feedInfo):
                self.lastId = feedInfo.lastId
            }
        }
    }


}

