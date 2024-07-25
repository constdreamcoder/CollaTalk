//
//  SelectPhotosView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/24/24.
//

import SwiftUI
import PhotosUI

struct SelectPhotosView<Content: View>: View {
    
    @EnvironmentObject private var store: AppStore
    
    /// PhotoPicker와 상호 연동할 수 있는 선택된 Item 배열 상태 프로퍼티
    @State private var selectedPhotos: [PhotosPickerItem] = []
    /// 로드 중 실패 시 상위 뷰에 에러를 띄워주기 위해 감지하는 바인딩 프로퍼티
    @Binding private var isPresentedError: Bool
    /// Item을 선택할 수 있는 최대 갯수
    private let maxSelectedCount: Int
    /// 최대 갯수가 선택된 여부에 따라 뷰와 기능을 비활성화 시킬 연산 프로퍼티
    private var disabled: Bool {
        store.state.chatState.selectedImages.count >= maxSelectedCount
    }
    /// 현재 선택된 아이템의 갯수를 가지고 최대 갯수와의 차이를 구하여 남은 선택 가능한 갯수 연산 프로퍼티
    private var availableSelectedCount: Int {
        maxSelectedCount - store.state.chatState.selectedImages.count
    }
    private let matching: PHPickerFilter
    private let photoLibrary: PHPhotoLibrary
    private let content: Content
    
    init(
        isPresentedError: Binding<Bool> = .constant(false),
        maxSelectedCount: Int = 5,
        matching: PHPickerFilter = .images,
        photoLibrary: PHPhotoLibrary = .shared(),
        content: () -> Content
    ) {
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
        .onChange(of: selectedPhotos, action: { newPhotos in
            store.dispatch(.chatAction(.handleSelectedPhotos(newPhotos: newPhotos)))
            selectedPhotos.removeAll()
        })
    }
}
