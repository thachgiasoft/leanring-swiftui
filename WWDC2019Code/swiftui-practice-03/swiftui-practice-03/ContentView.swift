//
//  ContentView.swift
//  swiftui-practice-03
//
//  Created by Won on 2019/10/11.
//  Copyright © 2019 Won. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                var width: CGFloat = min(geometry.size.width, geometry.size.height)
                var height = width
                let xScale: CGFloat = 0.5
                let yScale: CGFloat = 0.5

                let xOffset = (width * (1.0 - xScale)) / 2.0
                let yOffset = (width * (1.0 - yScale)) / 2.0

                width *= xScale
                height *= yScale

                path.move(to:
                    CGPoint(
                        x: xOffset + width * 0.5,
                        y: yOffset + height * 0)
                )

                path.addLine(to:
                    CGPoint(
                        x: xOffset + width * 0,
                        y: yOffset + height * 1)
                )

                path.addLine(to:
                    CGPoint(
                        x: xOffset + width * 1,
                        y: yOffset + height * 1
                    )
                )
            }
            .fill(LinearGradient(
                gradient: Gradient(
                    colors: [Color.blue, Color.green]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)))
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
