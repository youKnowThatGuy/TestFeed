//
//  ServerResponse.swift
//  TestFeed
//
//  Created by Клим on 21.07.2021.
//

import Foundation

struct ServerResponse: Decodable{
    var result: FeedEntries
}

struct FeedEntries: Decodable{
    var items: [SingleEntry]
    var lastId: Int
    var lastSortingValue: Double
}

struct SingleEntry: Decodable{
    var data: EntryData
}


struct EntryData: Decodable{
    var author: AuthorInfo
    var subsite: SubsiteInfo
    var title: String
    var date: Int
    var blocks: [SingleBlock]
    var counters: CounterInfo
    var likes: LikesInfo
}

struct LikesInfo: Decodable{
    var summ: Int
}

struct CounterInfo: Decodable{
    var comments: Int
}

struct SingleBlock: Decodable {
    var type: String
    var data: BlockInfo
    var cover: Bool
}

struct BlockInfo: Decodable{
    var text: String?
    var items: ItemType?
    var video: VideoInfo?
}

struct ImageInfo: Decodable {
    var data: PictureData
}

struct PictureData: Decodable {
    var uuid: String
}

struct MediaInfo: Decodable{
    var image: ImageInfo
}

struct VideoInfo: Decodable{
    var data: VideoData
}

struct VideoData: Decodable {
    var thumbnail: ThumbnailInfo
}

struct ThumbnailInfo: Decodable{
    var data: ThumbnailData
}

struct ThumbnailData: Decodable {
    var uuid: String
}

struct SubsiteInfo: Decodable {
    var name: String
    var avatar: ImageInfo
}



struct AuthorInfo: Decodable{
    var name: String
}


struct ItemType {
    let value: Any
    init<T>(_ value: T) {
        self.value = value
    }
}

extension ItemType: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let string = try? container.decode([String].self) {
            self.init(string)
        } else if let array = try? container.decode([MediaInfo].self) {
            self.init(array)
        }
        else if let dict = try? container.decode([String: String].self) {
            self.init(dict)
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "value cannot be decoded")
        }
    }
}

/*
enum MediaType: Codable {

    case string(Array<String>)
    case array(Array<MediaInfo>)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .array(try container.decode([MediaInfo].self))
        } catch DecodingError.typeMismatch {
            self = .string(try container.decode([String].self))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        }
 
    }

}
 */
