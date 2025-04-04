//
//  Sturldata.swift
//  EmojiArt
//
//  Created by Adelaide Jia on 2025/04/04.
//

import CoreTransferable

enum Sturldata: Transferable {
    case string(String)
    case url(URL)
    case data(Data)
    
    init(url: URL) {
        if let imageData = url.dataSchemeImageData {
            self = .data(imageData)
        } else {
            self = .url(url.imageURL)
        }
    }
    
    init(string: String) {
        if string.hasPrefix("http"), let url = URL(string: string) {
            self = .url(url.imageURL)
        } else {
            self = .string(string)
        }
    }
    
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation { Sturldata(string: $0) }
        ProxyRepresentation { Sturldata(url: $0) }
        ProxyRepresentation { Sturldata.data($0)}
    }
}

extension URL {
    var imageURL: URL {
        if let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems {
            for queryItem in queryItems {
                if let value = queryItem.value, value.hasPrefix("http"), let imgurl = URL(string: value) {
                    return imgurl
                }
            }
        }
        return self
    }
    
    var dataSchemeImageData: Data? {
            let urlString = absoluteString
            // is this a data scheme url with some sort of image as the mime type?
            if urlString.hasPrefix("data:image") {
                // yes, find the comma that separates the meta info from the image data
                if let comma = urlString.firstIndex(of: ","), comma < urlString.endIndex {
                    let meta = urlString[..<comma]
                    // we can only handle base64 encoded data
                    if meta.hasSuffix("base64") {
                        let data = String(urlString.suffix(after: comma))
                        // get the data
                        if let imageData = Data(base64Encoded: data) {
                            return imageData
                        }
                    }
                }
            }
            // not a data scheme or the data doesn't seem to be a base64 encoded image
            return nil
        }
}

extension Collection {
    // this will crash if after >= endIndex
    func suffix(after: Self.Index) -> Self.SubSequence {
        suffix(from: index(after: after))
    }
}
