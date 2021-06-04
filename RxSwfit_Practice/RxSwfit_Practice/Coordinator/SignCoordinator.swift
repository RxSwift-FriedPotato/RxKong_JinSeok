//
//  SignCoordinator.swift
//  RxSwfit_Practice
//
//  Created by 홍진석 on 2021/06/04.
//

import Foundation
import UIKit

class SignCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var nav: UINavigationController
    
    init(nav: UINavigationController){self.nav = nav}
    
    func move() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mainVC")
        nav.pushViewController(vc, animated: false)
    }
}
