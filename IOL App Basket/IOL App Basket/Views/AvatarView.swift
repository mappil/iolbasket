//
//  AvatarView.swift
//  IOL App Basket
//
//  Created by massimiliano allegretti on 23/06/25.
//

import SwiftUI
import Charts

struct AvatarView: View {
    let name: String
    
    var body: some View {
        AsyncImage(url: URL(string: "https://github.com/mappil/iolbasket/blob/main/avatars/\(name.lowercased()).jpg?raw=true")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Color.gray.opacity(0.3)
        }
        .clipShape(Circle())
    }
}

#Preview {
    AvatarView(name: "Max")
}
