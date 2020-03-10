//
//  ContentView.swift
//  Rooms
//
//  Created by kyle.jo on 2019/06/25.
//  Copyright © 2019 kyle.jo. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @ObservedObject var store = RoomStore()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: addRoom) {
                        Text("Add Room")
                    }
                }

                Section {
                    ForEach(store.rooms) { room in
                        RoomCell(room: room)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
            }
            .navigationBarTitle(Text("Rooms"))
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func addRoom() {
        store.rooms.append(Room(name: "Catalina", capacity: 100))
    }

    func delete(at offsets: IndexSet) {
        store.rooms.remove(atOffsets: offsets)
    }

    func move(from source: IndexSet, to destination: Int) {
        store.rooms.move(fromOffsets: source, toOffset: destination)
    }
}

struct RoomCell : View {
    let room: Room
    
    var body: some View {
        return NavigationLink(destination: RoomDetail(room: room)) {
            Image(room.thumbnailName)
                .cornerRadius(8.0)
            
            VStack(alignment: .leading) {
                Text(room.name)
                Text("\(room.capacity) people" )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(store: RoomStore(rooms: testData))            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .colorScheme(.dark)
//                .environment(\.sizeCategory, .extraExtraExtraLarge)
//                .environment(\.sizeCategory, .extraExtraExtraLarge)
//                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
#endif
