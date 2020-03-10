//
//  ContentView.swift
//  Movie
//
//  Created by Won on 2019/10/07.
//  Copyright © 2019 Won. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Won Jo")
            .bold()
            .italic()
            .underline(true, color: Color.green)
            .foregroundColor(Color.purple)
            .kerning(10)
            .strikethrough(true, color: Color.blue)
            .shadow(color: Color.black, radius: 5.0, x: 2, y: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
