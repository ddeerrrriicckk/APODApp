//
//  LoadingView.swift
//  APODApp
//
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Image(systemName: "arrow.2.circlepath.circle")
                .rotationEffect(.degrees(isLoading ? 360 : 0))
                .foregroundColor(.white)
                .font(.system(size: 40))
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isLoading = true
            }
        }
        .onDisappear {
            withAnimation {
                isLoading = false
            }
        }
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .background(Color.black)
    }
}

