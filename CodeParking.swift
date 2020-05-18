//
//  CodeParking.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/23/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct ContentView2: View {
    @State private var uiImage: UIImage? = nil
    @State private var rect1: CGRect = .zero
    @State private var rect2: CGRect = .zero

    var body: some View {
        VStack {
            ForEach(0 ..< gradiants.count) {
                gradiants[$0]
            }
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}



// below is from https://github.com/paololeonardi/WaterfallGrid
// Nice exemple of declaration with restriction for more generic use

public struct WaterfallGrid<Data, ID, Content>: View where Data : RandomAccessCollection, Content : View, ID : Hashable {
    public var body: some View {
        GeometryReader { geometry in
            EmptyView()
        }
    }
}

// SWIFT subscript concept
// https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html


struct ScoreCardsGridView2 {
    let rows: Int, columns: Int
    var grid: [PlayerScore]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: PlayerScore(player: Player(), pointsList: []), count: rows * columns)
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> PlayerScore {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}




// ----------------------------------------------
// ----------------------------------------------
// ----------------------------------------------
// ----------------------------------------------
                
                            

