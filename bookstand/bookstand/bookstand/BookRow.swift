//
//  BookRow.swift
//  bookstand
//
//  Created by Won on 2019/09/26.
//  Copyright © 2019 Won. All rights reserved.
//

import SwiftUI

struct BookRow: View {
    var book: Book

    var body: some View {
        HStack(alignment: .top) {
            Image("rdpd")
                .resizable()
                .frame(width: 100, height: 150)
                .aspectRatio(contentMode: .fit)

            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("저자").font(Font.caption)
                        .foregroundColor(Color.gray)
                    Text("역자").font(Font.caption)
                        .foregroundColor(Color.gray)
                    Text("가격").font(Font.caption)
                        .foregroundColor(Color.gray)
                    Text("출판사").font(Font.caption)
                        .foregroundColor(Color.gray)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(book.authors.joined(separator: ", "))
                        .font(Font.caption)
                    Text(book.translators.joined(separator: ", "))
                        .font(Font.caption)
                    Text(book.formattedSalePrice ?? "")
                        .font(Font.caption)
                    Text(book.publisher)
                        .font(Font.caption)
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            BookRow(book: sampleBook!)
        }
    }
}
