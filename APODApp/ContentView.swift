//
//  ContentView.swift
//  APODApp
//
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        APODView(viewModel: APODViewModel())
            .navigationTitle("Astronomy Picture of the Day")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
