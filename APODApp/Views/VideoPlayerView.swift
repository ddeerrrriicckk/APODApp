//
//  VideoPlayerView.swift
//  APODApp
//
//

import SwiftUI
import WebKit

struct VimeoPlayerView: UIViewRepresentable {
    @Binding var isLoading: Bool
    let webView = WKWebView()
    let videoURL: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<VimeoPlayerView>) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.loadHTMLString("", baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<VimeoPlayerView>) {
        let htmlString = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
            </head>
            <body style="margin: 0; background-color: black;">
                <div style="position:relative; width:100%; height:100%;">
                    <iframe src="\(videoURL.absoluteString)" frameborder="0" allow="autoplay; fullscreen" allowfullscreen style="position:absolute; top:0; left:0; width:100%; height:100%;"></iframe>
                </div>
            </body>
        </html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.backgroundColor = UIColor.black
        webView.isOpaque = false
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: VimeoPlayerView
        init(_ parent: VimeoPlayerView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }

    static func dismantleUIView(_ uiView: WKWebView, coordinator: ()) {
        uiView.loadHTMLString("", baseURL: nil)
    }
}

struct VimeoPlayerContainer: View {
    @State private var videoURL: URL
    @State private var isLoading = true
    
    init(videoURL: URL) {
        var urlStr = videoURL.absoluteString
        if urlStr.starts(with: "//") {
            urlStr = "https:" + urlStr
        } else if urlStr.starts(with: "http://") {
            urlStr = urlStr.replacingOccurrences(of: "http://", with: "https://")
        }
        _videoURL = State(initialValue: URL(string: urlStr)!)
    }
    
    var body: some View {
        ZStack {
            VimeoPlayerView(isLoading: $isLoading, videoURL: videoURL)
            
            if isLoading {
                LoadingView()
            }
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VimeoPlayerContainer(videoURL: URL(string: "//player.vimeo.com/video/108650530?title=0&byline=0&portrait=0&badge=0&color=ffffff")!).frame(width: 420, height: 360)
    }
}
