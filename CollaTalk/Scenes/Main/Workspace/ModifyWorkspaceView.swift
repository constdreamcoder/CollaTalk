//
//  ModifyWorkspaceView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/11/24.
//

import SwiftUI

enum WorkspaceModificationType {
    case create
    case edit
    
    var sheetNavigationFeature: SheetNavigation.Feature {
        switch self {
        case .create:
            return .createWorkspace
        case .edit:
            return .editWorkspace
        }
    }
}

struct ModifyWorkspaceView: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                SheetNavigation(
                    title: store.state.modifyWorkspaceState.workspaceModificationType.sheetNavigationFeature,
                    isPresented: Binding(
                        get: { store.state.navigationState.isModifyWorkspaceViewPresented },
                        set: { store.dispatch(.navigationAction(.presentModifyWorkspaceView(
                            present: $0,
                            workspaceModificationType: store.state.modifyWorkspaceState.workspaceModificationType)))
                        }
                    ),
                    transitionAction: {})
                
                // TODO: - 추후 리팩토링
                if store.state.modifyWorkspaceState.existingWorkspace == nil {
                    Image(uiImage: store.state.modifyWorkspaceState.selectedImageFromGallery ?? .workspace)
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 70)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                        .overlay(alignment: .bottomTrailing) {
                            Image(.camera)
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 24)
                                .offset(x: 5, y: 5)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.dispatch(.navigationAction(.showImagePickerView(show: true)))
                        }
                } else {
                    if store.state.modifyWorkspaceState.existingWorkspace?.coverImage == "" {
                        Image(uiImage: store.state.modifyWorkspaceState.selectedImageFromGallery ?? .workspace)
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 70)
                            .background(.brandGreen)
                            .cornerRadius(8, corners: .allCorners)
                            .overlay(alignment: .bottomTrailing) {
                                Image(.camera)
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: 24)
                                    .offset(x: 5, y: 5)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                store.dispatch(.navigationAction(.showImagePickerView(show: true)))
                            }
                    } else {
                        RemoteImage(path: store.state.modifyWorkspaceState.existingWorkspace?.coverImage) { image in
                            image
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 70)
                                .background(.brandGreen)
                                .cornerRadius(8, corners: .allCorners)
                                .overlay(alignment: .bottomTrailing) {
                                    Image(.camera)
                                        .resizable()
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .frame(width: 24)
                                        .offset(x: 5, y: 5)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    store.dispatch(.navigationAction(.showImagePickerView(show: true)))
                                }
                        } placeHolderView: {
                            Image(uiImage: store.state.modifyWorkspaceState.selectedImageFromGallery ?? .workspace)
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 70)
                                .background(.brandGreen)
                                .cornerRadius(8, corners: .allCorners)
                                .overlay(alignment: .bottomTrailing) {
                                    Image(.camera)
                                        .resizable()
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .frame(width: 24)
                                        .offset(x: 5, y: 5)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    store.dispatch(.navigationAction(.showImagePickerView(show: true)))
                                }
                        }
                    }
                    
                }
                
                InputView(
                    title: "워크스페이스 이름",
                    placeholder: "워크스페이스 이름을 입력하세요 (필수)",
                    textFieldGetter: { store.state.modifyWorkspaceState.name },
                    textFieldSetter: { store.dispatch(.modifyWorkspaceAction(.writeName(name: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                InputView(
                    title: "워크스페이스 설명",
                    placeholder: "워크스페이스를 설명하세요 (옵션)",
                    textFieldGetter: { store.state.modifyWorkspaceState.description },
                    textFieldSetter: { store.dispatch(.modifyWorkspaceAction(.writeDescription(description: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                Spacer()
                
                CustomButton {
                    switch store.state.modifyWorkspaceState.workspaceModificationType {
                    case .create:
                        print("워크스페이스 생성")
                        store.dispatch(.modifyWorkspaceAction(.addWorkspace))
                    case .edit:
                        print("워크스페이스 수정")
                        store.dispatch(.modifyWorkspaceAction(.editWorkspace))
                    }
                } label: {
                    switch store.state.modifyWorkspaceState.workspaceModificationType {
                    case .create:
                        Text("완료")
                    case .edit:
                        Text("저장")
                    }
                }
                .disabled(!modifyWorkspaceButtonValid)
                .bottomButtonShape(modifyWorkspaceButtonValid ? .brandGreen : .brandInactive)
            }
        }
        .onDisappear {
            store.dispatch(.modifyWorkspaceAction(.initializeAllElements))
        }
    }
}

extension ModifyWorkspaceView {
    private var modifyWorkspaceButtonValid: Bool {
        !store.state.modifyWorkspaceState.isNameEmpty
    }
}

#Preview {
    ModifyWorkspaceView()
}
