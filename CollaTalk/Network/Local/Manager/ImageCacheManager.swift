//
//  ImageManager.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/16/24.
//

import UIKit

final class ImageCacheManager {
        
    private enum Constants {
        /// 초기 제약: 500메가바이트
        static let initialByteLimit = 500 * megaByteUnit
        static let kiloByteUnit = 1024
        static let megaByteUnit = 1024 * 1024
    }
        
    static let shared = ImageCacheManager()
    
    private init() {
        cache.countLimit = countLimit
        cache.totalCostLimit = byteLimit
    }
        
    private let cache = NSCache<NSURL, UIImage>()
    
    /// 총 500개 까지만 캐싱
    private var countLimit = 500 {
        didSet { cache.countLimit = countLimit }
    }
    /// 메모리 캐싱 시의 용량 제약
    private var byteLimit: Int = Constants.initialByteLimit {
        didSet { cache.totalCostLimit = byteLimit }
    }
    private var megaByteLimit: Int {
        get { byteLimit / Constants.megaByteUnit }
        set { byteLimit = newValue * Constants.megaByteUnit }
    }
    private var kiloByteLimit: Int {
        get { byteLimit / Constants.kiloByteUnit }
        set { byteLimit = newValue * Constants.kiloByteUnit }
    }
        
    func get(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func store(_ value: UIImage, for url: URL) {
        let bytesOfImage = value.pngData()?.count ?? 0
        cache.setObject(value, forKey: url as NSURL, cost: bytesOfImage)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
