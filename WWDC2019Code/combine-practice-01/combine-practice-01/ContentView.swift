//
//  ContentView.swift
//  combine-practice-01
//
//  Created by Won on 2019/10/09.
//  Copyright © 2019 Won. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {

    func continueButtonAction() {

    }

    @State var progressValue01: CGFloat = 0.1
    @State var progressValue02: CGFloat = 0.1
    @State var progressValue03: CGFloat = 0.1

    @State var completed: Bool = false

    var body: some View {

        GeometryReader { geometry in
            VStack(spacing: 20) {

                VStack {
                    HStack(alignment: .center) {
                        Text("Organizing sparkles...")
                        Spacer()
                        if self.progressValue01 >= 0.9 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                        } else {
                            LineProgress(value: self.$progressValue01).frame(maxWidth: 70)
                        }
                    }
                    .frame(maxWidth: geometry.size.width - 50, maxHeight: 35)

                    HStack(alignment: .center) {
                        Text("Decomposing cellular material...")
                        Spacer()
                        if self.progressValue02 >= 0.9 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                        } else {
                            LineProgress(value: self.$progressValue02).frame(maxWidth: 70)
                        }
                    }
                    .frame(maxWidth: geometry.size.width - 50, maxHeight: 35)

                    HStack(alignment: .center) {
                        Text("Arraning discontinuity matrix...")
                        Spacer()
                        if self.progressValue03 >= 0.9 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                        } else {
                            LineProgress(value: self.$progressValue03).frame(maxWidth: 70)
                        }
                    }
                    .frame(maxWidth: geometry.size.width - 50, maxHeight: 35)
                }

                Button(action: self.continueButtonAction) {
                    Text("Continue")
                        .bold()
                        .padding(5)
                        .frame(maxWidth: geometry.size.width - 50, maxHeight: 35)
                }
                .foregroundColor(Color.white)
                .background(self.completed ? Color.blue : Color.secondary)
                .cornerRadius(10)
                .disabled(!self.completed)
            }
        }.onAppear {

            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in

                if (self.progressValue01 < 1.0) {
                    self.progressValue01 += CGFloat.random(in: 0..<0.3)
                }

                if (self.progressValue02 < 1.0) {
                    self.progressValue02 += CGFloat.random(in: 0..<0.3)
                }

                if (self.progressValue03 < 1.0) {
                    self.progressValue03 += CGFloat.random(in: 0..<0.3)
                }

                if self.progressValue03 >= 1.0 &&
                    self.progressValue02 >= 1.0 &&
                    self.progressValue01 >= 1.0 {
                    self.completed = true
                    timer.invalidate()
                }
            }
        }
    }
}

struct LineProgress: View {

    @Binding var value: CGFloat

    var body: some View {
        GeometryReader { geometry in

            ZStack(alignment: .leading) {
                Rectangle().opacity(0.1)
                Rectangle()
                    .frame(minWidth: 0,
                           idealWidth: geometry.frame(in: .global).size.width * self.value,
                           maxWidth: geometry.frame(in: .global).size.width * self.value)
                    .opacity(0.5)
                    .background(Color.primary)
                    .animation(.easeInOut)
            }
            .frame(height: 3)
        }
    }
}


#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {

            ContentView()
                .environment(\.colorScheme, .light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))


            ContentView()
                .environment(\.colorScheme, .dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
        }
    }
}
#endif
