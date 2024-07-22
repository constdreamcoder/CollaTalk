//
//  DMListView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/22/24.
//

import SwiftUI

struct DMListView: View {
    var body: some View {
        VStack {
            DMMemberListView()
            
            Divider()
            
            DMListContent()
        }
    }
}

#Preview {
    DMListView()
}

struct DMMemberListView: View {
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(0..<20) { _  in
                    VStack(spacing: 4) {
                        Image(.kakaoLogo)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 44)
                            .background(.brandGreen)
                            .cornerRadius(8, corners: .allCorners)
                        
                        Text("뚜비두밥")
                            .font(.body)
                    }
                    .padding(16)
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(height: 96)
    }
}

struct DMListContent:View {
    var body: some View {
        List {
            ForEach(0..<5) { _ in
                HStack(alignment: .top) {
                    Image(.kakaoLogo)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 34)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                    
                    VStack {
                        HStack {
                            Text("옹골찬 고래밥")
                                .font(.caption)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("PM 11:23")
                                .font(.caption2)
                                .foregroundStyle(.textSecondary)
                                .lineLimit(1)
                                .multilineTextAlignment(.trailing)
                        }
                       
                        HStack(alignment: .top) {
                            Text("Cause I know what you like boy You're my chemical hype boy 내 지난날들은 눈 뜨면 잊는 꿈 Hype boy 너만원호호호홓")
                                .font(.caption2)
                                .foregroundStyle(.textSecondary)
                                .lineLimit(2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("99")
                                .font(.caption)
                                .foregroundColor(.brandWhite)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(.brandGreen)
                                .cornerRadius(8, corners: .allCorners)
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
