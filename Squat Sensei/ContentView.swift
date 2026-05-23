//
//  ContentView.swift
//  Squat Sensei
//
//  Created by 湯川昇平 on 2026/05/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
