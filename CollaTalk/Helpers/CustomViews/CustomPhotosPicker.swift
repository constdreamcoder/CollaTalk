//
//  CustomPhotosPicker.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/24/24.
//

import SwiftUI
import PhotosUI

struct CustomPhotosPicker<Content: View>: View {
    
    /// PhotoPicker와 상호 연동할 수 있는 선택된 Item 배열 상태 프로퍼티
    @State private var selectedPhotos: [PhotosPickerItem]
    /// 실제 해당 컴포넌트를 호출한 상위 뷰와 바인딩 시킬 이미지 배열 프로퍼티
    @Binding private var selectedImages: [UIImage]
    /// 로드 중 실패 시 상위 뷰에 에러를 띄워주기 위해 감지하는 바인딩 프로퍼티
    @Binding private var isPresentedError: Bool
    /// Item을 선택할 수 있는 최대 갯수
    private let maxSelectedCount: Int
    /// 최대 갯수가 선택된 여부에 따라 뷰와 기능을 비활성화 시킬 연산 프로퍼티
    private var disabled: Bool {
        selectedImages.count >= maxSelectedCount
    }
    /// 현재 선택된 아이템의 갯수를 가지고 최대 갯수와의 차이를 구하여 남은 선택 가능한 갯수 연산 프로퍼티
    private var availableSelectedCount: Int {
        maxSelectedCount - selectedImages.count
    }
    private let matching: PHPickerFilter
    private let photoLibrary: PHPhotoLibrary
    private let content: Content
    
    init(
        selectedPhotos: [PhotosPickerItem] = [],
        selectedImages: Binding<[UIImage]>,
        isPresentedError: Binding<Bool> = .constant(false),
        maxSelectedCount: Int = 5,
        matching: PHPickerFilter = .images,
        photoLibrary: PHPhotoLibrary = .shared(),
        content: () -> Content
    ) {
        self.selectedPhotos = selectedPhotos
        self._selectedImages = selectedImages
        self._isPresentedError = isPresentedError
        self.maxSelectedCount = maxSelectedCount
        self.matching = matching
        self.photoLibrary = photoLibrary
        self.content = content()
    }
    
    var body: some View {
        PhotosPicker(
            selection: $selectedPhotos,
            maxSelectionCount: availableSelectedCount,
            matching: matching,
            photoLibrary: photoLibrary
        ) {
            content
                .disabled(disabled)
        }
        .disabled(disabled)
        .onChange(of: selectedPhotos, action: { newValue in
            handleSelectedPhotos(newValue)
        })
    }
    
    private func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
        for newPhoto in newPhotos {
            newPhoto.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let newImage = UIImage(data: data) {
                        if !selectedImages.contains(where: { $0.pngData() == newImage.pngData() }) {
                            DispatchQueue.main.async {
                                selectedImages.append(newImage)
                            }
                        }
                    }
                case .failure:
                    isPresentedError = true
                }
            }
        }
        
        selectedPhotos.removeAll()
    }
}
