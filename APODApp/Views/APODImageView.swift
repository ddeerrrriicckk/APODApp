//
//  APODImageView.swift
//  APODApp
//
//

import SwiftUI
import Combine

struct APODImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State private var image: UIImage = UIImage()
    @State private var isFullScreen = false
    @State private var scale: CGFloat = 1.0
    
    init(url: String?) {
        imageLoader = ImageLoader(url: url)
    }

    var body: some View {
        ZStack {
            if imageLoader.imageData.isEmpty && !imageLoader.isCached {
                LoadingView()
            } else {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        isFullScreen.toggle()
                    }
                    .fullScreenCover(isPresented: $isFullScreen) {
                        GeometryReader { geometry in
                            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                                ZStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .edgesIgnoringSafeArea(.all)
                                        .scaleEffect(scale)
                                        .gesture(MagnificationGesture()
                                            .onChanged { value in
                                                scale = value.magnitude
                                            }
                                        )
                                    
                                    VStack {
                                        HStack {
                                            Button(action: {
                                                isFullScreen.toggle()
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(.black)
                                            }
                                            .padding()
                                            
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height)
                            }
                        }
                    }
            }
        }
        .onReceive(imageLoader.$imageData) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var imageData = Data()
    var isCached: Bool = false

    private var cancellable: AnyCancellable?

    init(url: String?) {
        guard let urlString = url, let url = URL(string: urlString) else { return }

        let cache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: "APODImageCache")
        let config = URLSessionConfiguration.default
        config.urlCache = cache

        let request = URLRequest(url: url)
        if let cachedResponse = cache.cachedResponse(for: request) {
            imageData = cachedResponse.data
            isCached = true
        } else {
            cancellable = URLSession(configuration: config).dataTaskPublisher(for: url)
                .map(\.data)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { data in
                    self.imageData = data
                })
        }
    }

    deinit {
        cancellable?.cancel()
    }
}
