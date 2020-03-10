//
//  RoomDetail.swift
//  Rooms
//
//  Created by kyle.jo on 2019/06/26.
//  Copyright © 2019 kyle.jo. All rights reserved.
//

import SwiftUI

struct RoomDetail : View {
    let room: Room
    @State private var zoomed = false // Source of Truth

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(room.imageName)
                .resizable()
                .aspectRatio(contentMode: zoomed ? .fill : .fit) // contentMode - Derived Value
                .navigationBarTitle(Text(room.name), displayMode: .inline)
                .onTapGesture {
                    withAnimation(.easeIn(duration: 2)) { self.zoomed.toggle() }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

            if room.hasVideo && !zoomed {
                Image(systemName: "video.fill")
                    .font(.title)
                    .padding(.all)
                    .transition(.move(edge: .leading))
            }
        }
    }
}

#if DEBUG
struct RoomDetail_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                RoomDetail(room: testData[0])
            }
            NavigationView {
                RoomDetail(room: testData[1])
            }
        }
    }
}
#endif
