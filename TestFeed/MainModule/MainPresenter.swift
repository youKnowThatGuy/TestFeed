//
//  MainPresenter.swift
//  TestFeed
//
//  Created by Клим on 23.07.2021.
//

import UIKit

protocol MainPresenterProtocol{
    init(view: MainViewProtocol)
    func feedCount() -> Int
    func prepareCell(cell: FeedBaseProtocol, index: Int, imageId: String) -> UITableViewCell
    func checkCellType(index: Int) -> String
    func loadData()
}

class MainPresenter: MainPresenterProtocol{
    
    weak var view: MainViewProtocol?
    var entries = [SingleEntry]()
    var lastId = "none"
    var lastSortingValue = ""
    
    required init(view: MainViewProtocol) {
        self.view = view
        loadData()
    }
    
    func feedCount() -> Int{
        entries.count
    }
    
    func prepareCell(cell: FeedBaseProtocol, index: Int, imageId: String) -> UITableViewCell {
        let entry = entries[index]
        cell.parentController = view
        cell.authorNameLabel.text = entry.data.author.name
        cell.commentCountLabel.text = "\(entry.data.counters.comments)"
        cell.likesCountLabel.text = "\(entry.data.likes.summ)"
        cell.subsiteName.text = entry.data.subsite.name
        cell.titleLabel.text = entry.data.title
        cell.dateLabel.text = calcTime(timeStamp: entry.data.date)
        
        if  let cast = cell as? FeedViewCell{
        NetworkService.shared.loadImage(from: imageId, completion: { (image) in
            cast.postImage.image = image
            NetworkService.shared.loadImage(from: entry.data.subsite.avatar.data.uuid) { (image) in
                cast.subsiteLogo.image = image
            }
        })
            return cast
        }
        else{

        NetworkService.shared.loadImage(from: entry.data.subsite.avatar.data.uuid) { (image) in
            cell.subsiteLogo.image = image
        }
        return cell
        }
        
    }
    
    func checkCellType(index: Int) -> String{
        let entry = entries[index]
        var imageId = ""
        for block in entry.data.blocks{
            if block.cover == true && block.type == "media"{
                let mediaArray = block.data.items!.value as! [MediaInfo]
                imageId =  mediaArray[0].image.data.uuid
            }
            else if block.cover == true && block.type == "video"{
                imageId = (block.data.video?.data.thumbnail.data.uuid)!
            }
        }
       return imageId
    }
    
    func calcTime(timeStamp: Int) -> String{
        let currTime = Int(Date().timeIntervalSince1970)
        let timePassed = currTime - timeStamp
        var answer = ""
        if timePassed < 3600{
            answer = "<1 час"
        }
        else if timePassed < 86400{
            let hours = Int(timePassed / 3600)
            answer = "\(hours) час"
        }
        else if timePassed < 604800{
            let days = Int(timePassed / 86400)
            answer = "\(days) дней"
        }
        else{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            formatter.locale = Locale(identifier: "ru_RU")
            answer = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
        }
        return answer
    }
    
    func loadData(){
        NetworkService.shared.fetchSingleStockData(lastId: lastId, lastSortingValue: lastSortingValue) { (result) in
            switch result{
            case let .success(rawEntries):
                self.entries += rawEntries.items
                print("Entries added")
                self.lastId = "\(rawEntries.lastId)"
                self.lastSortingValue = "\(rawEntries.lastSortingValue)"
                self.view?.changeLoadingStatus()
                self.view?.updateUI()
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
}
