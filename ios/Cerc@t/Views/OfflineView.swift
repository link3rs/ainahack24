//
//  OfflineView.swift
//  Cerc@t
//
//  Created by Luis Lasierra on 9/11/24.
//

import SwiftUI

struct OfflineView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            VStack {
                Text("No network connection")
                    .font(.headline)
                Text("App requires internet connection to work.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct OffLineView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineView()
    }
}
