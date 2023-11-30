//
//  APODDetailView.swift
//  APODApp
//
//

import SwiftUI

struct APODDetailView: View {
    @ObservedObject var viewModel: APODViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Text(viewModel.apod?.title ?? "No Title")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .frame(height: geometry.size.height * 0.2)
                    .background(Color.black)
                Spacer()
                
                ScrollView {
                    Text(viewModel.apod?.explanation ?? "No Explanation")
                        .padding()
                        .foregroundColor(.white)
                }
                .frame(height: geometry.size.height * 0.7)
                .background(Color.black)
                
                Text(viewModel.apod?.copyright ?? "No Copyright")
                    .padding()
                    .foregroundColor(.white)
                    .frame(height: geometry.size.height * 0.1)
                    .background(Color.black)
            }
        }
    }
}

struct APODDetailView_Previews: PreviewProvider {
    static var previews: some View {
        APODDetailView(viewModel: APODViewModel())
            .background(Color.black)
    }
}
