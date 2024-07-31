//
//  CoverImageViewModel.swift
//  Record
//
//  Created by nomamac2 on 6/17/24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class CoverImageViewModel: ObservableObject {
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image, UIImage)
        case failure(Error)
    }

    enum TransferError: Error {
        case importFailed
    }

    struct CoverImage: Transferable {
        let image: Image
        let uiImage: UIImage

        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                // Only work when platform can import UIKit
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return CoverImage(image: image, uiImage: uiImage)
            }
        }
    }

    @Published private(set) var imageState: ImageState = .empty

    // @Published private(set) var selectedUIImage: UIImage? = nil

    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: CoverImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item")
                    return
                }
                switch result {
                case .success(let coverImage?):
                    self.imageState = .success(coverImage.image, coverImage.uiImage)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }

    func selectAgain() {
        imageState = .empty
    }
}
