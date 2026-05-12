//
//  AppBackground.swift
//  BookVault
//
//  Created by Mathesh Yogeswaran on 08/05/2026.
//

import SwiftUI

struct AppBackground<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(
                colors: [.blue.opacity(0.8), .purple.opacity(0.9)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            content
        }
    }
}
