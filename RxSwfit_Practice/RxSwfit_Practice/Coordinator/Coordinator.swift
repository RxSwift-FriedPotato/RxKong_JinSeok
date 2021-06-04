//
//  Coordinator.swift
//  RxSwfit_Practice
//
//  Created by 홍진석 on 2021/06/04.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var nav: UINavigationController {get set}
    
    func move()
}

