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
        MovingCounter(number: 25)
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

struct MovingCounter: View {
    let number: Double
    
    var body: some View {
        Text("00")
            .modifier(MovingCounterModifier(number: number))
    }
    
    struct MovingCounterModifier: AnimatableModifier {
        @State private var height: CGFloat = 0
        
        var number: Double
        
        var animatableData: Double {
            get { number }
            set { number = newValue }
        }
        
        func body(content: Content) -> some View {
            let n = self.number + 1
            
            let tOffset: CGFloat = getOffsetForTensDigit(n)
            let uOffset: CGFloat = getOffsetForUnitDigit(n)
            
            let u = [n - 2, n - 1, n + 0, n + 1, n + 2].map { getUnitDigit($0) }
            let x = getTensDigit(n)
            var t = [abs(x - 2), abs(x - 1), abs(x + 0), abs(x + 1), abs(x + 2)]
            t = t.map { getUnitDigit(Double($0)) }
            
            let font = Font.custom("Menlo", size: 34).bold()
            
            return HStack(alignment: .top, spacing: 0) {
                VStack {
                    Text("\(t[0])").font(font)
                    Text("\(t[1])").font(font)
                    Text("\(t[2])").font(font)
                    Text("\(t[3])").font(font)
                    Text("\(t[4])").font(font)
                }.foregroundColor(.green).modifier(ShiftEffect(pct: tOffset))
                
                VStack {
                    Text("\(u[0])").font(font)
                    Text("\(u[1])").font(font)
                    Text("\(u[2])").font(font)
                    Text("\(u[3])").font(font)
                    Text("\(u[4])").font(font)
                }.foregroundColor(.green).modifier(ShiftEffect(pct: uOffset))
            }
            .clipShape(ClipShape())
            .overlay(CounterBorder(height: $height))
            .background(CounterBackground(height: $height))
        }
        
        func getUnitDigit(_ number: Double) -> Int {
            return abs(Int(number) - ((Int(number) / 10) * 10))
        }
        
        func getTensDigit(_ number: Double) -> Int {
            return abs(Int(number) / 10)
        }
        
        func getOffsetForUnitDigit(_ number: Double) -> CGFloat {
            return 1 - CGFloat(number - Double(Int(number)))
        }
        
        func getOffsetForTensDigit(_ number: Double) -> CGFloat {
            if getUnitDigit(number) == 0 {
                return 1 - CGFloat(number - Double(Int(number)))
            } else {
                return 0
            }
        }
        struct CounterBorder: View  {
            @Binding var height: CGFloat
            
            var body: some View {
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 5.0).stroke(lineWidth: 5).foregroundColor(Color.blue).frame(width: 80, height: proxy.size.height / 5.0 + 30)
                }
            }
        }
        
        struct CounterBackground: View {
            @Binding var height: CGFloat
            
            var body: some View {
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 5.0).fill(Color.black).frame(width: 80, height: proxy.size.height / 5.0 + 30)
                }
            }
        }
        
        struct ClipShape: Shape {
            func path(in rect: CGRect) -> Path {
                let r = rect
                let h = (r.height / 5.0 + 30.0)
                var p = Path()
                
                let cr = CGRect(x: 0, y: (r.height - h) / 2.0, width: r.width, height: h)
                p.addRoundedRect(in: cr, cornerSize: CGSize(width: 5.0, height: 5.0))
                
                return p
            }
        }
        struct ShiftEffect: GeometryEffect {
            var pct: CGFloat = 1.0
            
            func effectValue(size: CGSize) -> ProjectionTransform {
                return .init(.init(translationX: 0, y: (size.height / 5.0) * pct))
            }
        }
    }
}

