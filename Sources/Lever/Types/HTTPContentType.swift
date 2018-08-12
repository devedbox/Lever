//
//  HTTPContentType.swift
//  Lever
//
//  Created by devedbox on 2018/8/10.
//

import Foundation

// MARK: - Error.

extension Lever.Error {
    public static let invalidHTTPContentTypeValue = Lever.Error(description: "The given value of Content-Type has invalid format.")
}

// MARK: - HTTPContentType.

public struct HTTPContentType {
    
    public let type: String
    public let subtype: String
    
    public init(type: String, subtype: String) {
        self.type = type
        self.subtype = subtype
    }
    
    public init(value: String) throws {
        let raws = value.split(separator: "/").map { String($0) }
        guard raws.count == 2 else {
            throw Lever.Error.invalidHTTPContentTypeValue
        }
        
        self.init(type: raws[0], subtype: raws[1])
    }
}

// MARK: - CustomStringConvertible.

extension HTTPContentType: CustomStringConvertible {
    public var description: String {
        return "\(type)/\(subtype)"
    }
}

// MARK: - Text.

extension HTTPContentType {
    public static func text(_ subtype: String) -> HTTPContentType {
        return HTTPContentType(type: "text", subtype: subtype)
    }
    
    public struct Text {
        public static let plain: HTTPContentType = .text("plain")
        public static let html: HTTPContentType = .text("html")
        public static let css: HTTPContentType = .text("css")
        public static let javascript: HTTPContentType = .text("javascript")
    }
}

// MARK: - Image.

extension HTTPContentType {
    public static func image(_ subtype: String) -> HTTPContentType {
        return HTTPContentType(type: "image", subtype: subtype)
    }
    
    public struct Image {
        public static let gif: HTTPContentType = .image("gif")
        public static let png: HTTPContentType = .image("png")
        public static let jpeg: HTTPContentType = .image("jpeg")
        public static let bmp: HTTPContentType = .image("bmp")
        public static let webp: HTTPContentType = .image("webp")
    }
}

// MARK: - Audio.

extension HTTPContentType {
    public static func audio(_ subtype: String) -> HTTPContentType {
        return HTTPContentType(type: "audio", subtype: subtype)
    }
    
    public struct Audio {
        public static let midi: HTTPContentType = .audio("midi")
        public static let mpeg: HTTPContentType = .audio("mpeg")
        public static let webm: HTTPContentType = .audio("webm")
        public static let ogg: HTTPContentType = .audio("ogg")
        public static let wav: HTTPContentType = .audio("wav")
    }
}

// MARK: - Video.

extension HTTPContentType {
    public static func video(_ subtype: String) -> HTTPContentType {
        return HTTPContentType(type: "video", subtype: subtype)
    }
    
    public struct Video {
        public static let webm: HTTPContentType = .video("webm")
        public static let ogg: HTTPContentType = .video("ogg")
    }
}

// MARK: - Binary.

extension HTTPContentType {
    public static func binary(_ subtype: String) -> HTTPContentType {
        return HTTPContentType(type: "application", subtype: subtype)
    }
    
    public struct Application {
        public static let unknown: HTTPContentType = .binary("octet-stream")
        public static let json: HTTPContentType = .binary("json")
        public static let xml: HTTPContentType = .binary("xml")
        public static let plist: HTTPContentType = .binary("x-plist")
    }
}

// MARK: - MultipartBinary.

extension HTTPContentType {
    public static func multipart(_ subtype: String) -> HTTPContentType {
        return HTTPContentType(type: "multipart", subtype: subtype)
    }
    
    public struct Multipart {
        public static let formData: HTTPContentType = .multipart("form-data")
    }
}
