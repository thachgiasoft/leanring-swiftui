//
//  ImageService.swift
//  bookstand
//
//  Created by Won on 2019/09/26.
//  Copyright © 2019 Won. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

class ImageService {
    static func fetchImage(path: String) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: URL(fileURLWithPath: path))
            .tryMap { (data, response) -> UIImage? in
                return UIImage(data: data)
        }.catch { error in
            return Just(nil)
        }
        .eraseToAnyPublisher()
    }
}

class ImageLoaderCache {
    static let shared = ImageLoaderCache()

    var loaders: NSCache<NSString, ImageLoader> = NSCache()

    func loaderFor(path: String) -> ImageLoader {
        let key = NSString(string: "\(path)")
        if let loader = loaders.object(forKey: key) {
            return loader
        } else {
            let loader = ImageLoader(path: path)
            loaders.setObject(loader, forKey: key)
            return loader
        }
    }
}

final class ImageLoader: ObservableObject {
    let path: String?

    var objectWillChange: AnyPublisher<UIImage?, Never> = Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()

    @Published var image: UIImage? = nil

    var cancellable: AnyCancellable?

    init(path: String?) {
        self.path = path

        self.objectWillChange = $image.handleEvents(receiveSubscription: { [weak self] sub in
            self?.loadImage()
        }, receiveCancel: { [weak self] in
            self?.cancellable?.cancel()
        }).eraseToAnyPublisher()
    }

    private func loadImage() {
        guard let path = path, image == nil else {
            return
        }
        cancellable = ImageService.fetchImage(path: path)
            .receive(on: DispatchQueue.main)
            .assign(to: \ImageLoader.image, on: self)
    }

    deinit {
        cancellable?.cancel()
    }
}
