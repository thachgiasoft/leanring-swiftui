//
//  RoomStore.swift
//  Rooms
//
//  Created by kyle.jo on 2019/06/26.
//  Copyright © 2019 kyle.jo. All rights reserved.
//

import SwiftUI
import Combine

class RoomStore : ObservableObject {

    var rooms: [Room] {
        didSet {
            didChange.send()
        }
    }
    
    init(rooms: [Room] = []) {
        self.rooms = rooms
    }
    
    var didChange = PassthroughSubject<Void, Never>()
}
