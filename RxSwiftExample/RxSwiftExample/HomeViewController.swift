//
//  HomeViewController.swift
//  RxSwiftExample
//
//  Created by Jervy Umandap on 8/16/24.
//

import UIKit
import ChameleonFramework
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    var circleView: UIView!
    let circleViewModel = CircleViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        view.backgroundColor = .systemBackground
        setup()
    }
    
    func setup() {
        // Add circle view
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .systemGreen
        view.addSubview(circleView)
        
        circleView
            .rx.observe(CGPoint.self, "center")
            .bind(to: circleViewModel.centerVariable)
            .disposed(by: disposeBag)
        
        circleViewModel.backgroundColorObservable
            .subscribe { [weak self] backgroundColor in
                UIView.animate(withDuration: 0.1) {
                    self?.circleView.backgroundColor = backgroundColor
                    
                    let viewBackgroundColor  = UIColor(complementaryFlatColorOf: backgroundColor)
                    
                    if viewBackgroundColor != backgroundColor {
                        self?.view.backgroundColor = viewBackgroundColor
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }
    
}
