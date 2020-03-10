//
//  ContentView.swift
//  combine-practice-01
//
//  Created by Won on 2019/10/09.
//  Copyright © 2019 Won. All rights reserved.
//

import SwiftUI
import Combine


final class ToggleModel: ObservableObject {


    @Published var allCompleted: Bool = false

    @Published var readManual: Bool = false
    @Published var practicedInSimulator: Bool = false
    @Published var teacherApproved: Bool = false

    private var anyCancellable: AnyCancellable?

    init() {
        anyCancellable = Publishers
            .CombineLatest3($readManual, $practicedInSimulator, $teacherApproved)
            .map({ $0 && $1 && $2 })
            .assign(to: \.allCompleted, on: self)
    }
}

struct ContentView: View {

    func continueButtonAction() {
        withAnimation {
            toggleModel.readManual.toggle()
            toggleModel.practicedInSimulator.toggle()
            toggleModel.teacherApproved.toggle()
        }
    }

    @EnvironmentObject var toggleModel: ToggleModel
    @State var allCompleted: Bool = false

    var body: some View {

        GeometryReader { geometry in
            VStack(spacing: 20) {
                VStack {
                    Toggle(isOn: self.$toggleModel.readManual.animation()) {
                        Text("Read manual 📒")
                    }
                    .frame(maxWidth: geometry.size.width - 50, maxHeight: 35)

                    Toggle(isOn: self.$toggleModel.practicedInSimulator.animation()) {
                        Text("Practiced in Simulator 🕹")
                    }
                    .frame(maxWidth: geometry.size.width - 50, maxHeight: 35)

                    Toggle(isOn: self.$toggleModel.teacherApproved) {
                        Text("Teacher Approved 🧙🏻‍♂️")
                    }
                    .frame(maxWidth: geometry.size.width - 50, maxHeight: 35)
                }

                Button(action: self.continueButtonAction) {
                    Text("Play")
                        .bold()
                        .padding(5)
                        .frame(maxWidth: geometry.size.width - 50, maxHeight: 35)
                }
                .foregroundColor(Color.white)
                .background(self.allCompleted ? Color.blue : Color.secondary)
                .cornerRadius(10)
                .disabled(!self.allCompleted)

            }.onReceive(self.toggleModel.$allCompleted) { output in
                self.allCompleted = output
            }
        }
    }
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(ToggleModel())
                .environment(\.colorScheme, .light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

            ContentView()
            .environmentObject(ToggleModel())
            .environment(\.colorScheme, .dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
        }
    }
}
#endif
