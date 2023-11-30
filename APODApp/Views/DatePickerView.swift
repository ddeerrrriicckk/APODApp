//
//  DatePickerView.swift
//  APODApp
//
//

import SwiftUI

struct DatePickerView: View {
    @State private var selectedDate = Date()
    @Binding var isDatePickerPresented: Bool

    let onDateSelected: (Date) -> Void

    var body: some View {
        VStack {
            let startDate = Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 16))!
            let dateRange: ClosedRange<Date> = startDate...Date()
            Spacer()
            ZStack {
                
            }
            DatePicker("", selection: $selectedDate, in: dateRange, displayedComponents: [.date])
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
                .colorInvert()
                .colorMultiply(.white)
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onChange(of: selectedDate) { newValue in
                    onDateSelected(newValue)
                }
        }
        .background(Color.clear)
    }
}





struct DatePickerView_Previews: PreviewProvider {
    @State static private var isDatePickerPresented = true
    
    static var previews: some View {
        DatePickerView(isDatePickerPresented: $isDatePickerPresented, onDateSelected: { _ in })
            .previewLayout(.fixed(width: 320, height: 568))
            .previewDisplayName("test")
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .regular)
    }
}
