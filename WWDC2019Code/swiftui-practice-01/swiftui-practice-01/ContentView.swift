//
//  ContentView.swift
//  swiftui-practice-01
//
//  Created by Won on 2019/10/10.
//  Copyright © 2019 Won. All rights reserved.
//

import SwiftUI

struct HelloView: View {
    var body: some View {
        Text("This is Hello View")
    }
}

struct DetailView: View {
    @Environment(\.presentationMode) var presentation
    @State var sayHello = false

    var body: some View {
        Group {
            Text("Details")

            VStack(spacing: 30) {
                Button(action: { self.presentation.wrappedValue.dismiss()}
                ) {
                    Text("Pop")
                }

                Button(action: {
                    self.sayHello.toggle()
                }) {
                    Text("Sheet")
                }
                .sheet(isPresented: $sayHello) {
                    HelloView()
                }

            }

        }
    }
}

struct ContentView: View {

    @State private var message: Message?
    @State private var showActionSheet = false


    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                NavigationLink(destination: DetailView()) {
                    Text("Show Detail View")
                }.navigationBarTitle("Navigation")

                Button("Show alert") {
                    self.message = Message(text: "Hi!")
                }

                Button("Show action sheet") {
                    self.showActionSheet.toggle()
                }
            }
        }.alert(item: $message) { message in
            Alert(
                title: Text(message.text),
                dismissButton: .cancel()
            )
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Actions"),
                message: Text("Available actions"),
                buttons: [
                    .cancel { print(self.showActionSheet) },
                    .default(Text("Action")),
                    .destructive(Text("Delete"))
                ]
            )
        }
    }
}


struct Message: Identifiable {
    let id = UUID()
    let text: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
