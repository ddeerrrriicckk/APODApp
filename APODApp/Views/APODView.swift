//
//  APODView.swift
//  APODApp
//
//

import SwiftUI

struct APODView: View {
    @ObservedObject var viewModel: APODViewModel
    @State private var isDatePickerPresented = false
    @State private var arrowDirection = "chevron.down"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TabView {
                    HStack(spacing: 0) {
                        VStack {
                            HStack(spacing: 0) {
                                if let errorMessage = viewModel.errorMessage {
                                    Text(errorMessage)
                                        .font(.title)
                                        .foregroundColor(.red)
                                        .padding()
                                } else {
                                    Text(formatDate(viewModel.apod?.date))
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 2)
                                            .alignmentGuide(.leading) { d in d[.leading] }
                                        Image(systemName: arrowDirection)
                                            .foregroundColor(.white)
                                            .font(.title)
                                            .padding(.horizontal, 2)
                                            .alignmentGuide(.trailing) { d in d[.trailing] }
                                }
                                
                            }
                            .onTapGesture {
                                isDatePickerPresented.toggle()
                                arrowDirection = isDatePickerPresented ? "chevron.up" : "chevron.down"
                            }
                            
                            if viewModel.apod?.media_type == "video" {
                                VimeoPlayerContainer(videoURL: URL(string: viewModel.apod!.url)!)
                            } else {
                                APODImageView(url: viewModel.apod?.url)
                                    .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
                            }
                            
                            
                            Spacer()
                            
                            Text(viewModel.apod?.title ?? "No Title")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.2)
                                .background(Color.black)
                                .offset(y: isDatePickerPresented ? -geometry.size.height * 0.23 : 0)
                                .onTapGesture {
                                    isDatePickerPresented.toggle()
                                    arrowDirection = isDatePickerPresented ? "chevron.up" : "chevron.down"
                                }
                        }
                        .background(Color.black)
                    }
                    APODDetailView(viewModel: viewModel)
                }
                .background(Color.black)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                
                if isDatePickerPresented {
                    DatePickerView(isDatePickerPresented: $isDatePickerPresented, onDateSelected: { date in
                        viewModel.fetchAPODData(for: date)
                    })
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                    .offset(y: geometry.size.height * 0.2)
                }


            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height < -50 {
                            viewModel.fetchPreviousAPODData()
                        } else if value.translation.height > 50 {
                            viewModel.fetchNextAPODData()
                        }
                    }
            )
        }
    }
    
    func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "No Date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return "Invalid Date" }
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}


struct APODView_Previews: PreviewProvider {
    static var previews: some View {
        APODView(viewModel: APODViewModel())
    }
}
