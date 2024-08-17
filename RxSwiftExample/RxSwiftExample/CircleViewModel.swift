//
//  CircleViewModel.swift
//  RxSwiftExample
//
//  Created by Jervy Umandap on 8/16/24.
//

import Foundation
import ChameleonFramework
import RxSwift
import RxCocoa

class CircleViewModel {    
    
    var centerVariable = BehaviorRelay<CGPoint?>(value: .zero)
    var backgroundColorObservable: Observable<UIColor>!
    var cornerRadiusObservable: Observable<CGFloat>! // to do
    
    init() {
        setup()
    }

    func setup() {
        // When we get new center, emit new UIColor
        backgroundColorObservable = centerVariable.asObservable()
            .map { center in
                guard let center else { return UIColor.flatten(.black)() }
                
                let red: CGFloat = ((center.x + center.y).truncatingRemainder(dividingBy: 255.0)) / 255.0 // // We just manipulate red, but you can do w/e
                let green: CGFloat = 0.0
                let blue: CGFloat = 0.0
                
                return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
            }
    }
    
}
