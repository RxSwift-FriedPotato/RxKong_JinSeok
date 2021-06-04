//
//  HomeCoordinator.swift
//  RxSwfit_Practice
//
//  Created by 홍진석 on 2021/06/04.
//

import Foundation
import UIKit

protocol HomeCoordinator: AnyObject {
  func pushToNext(_ navigationController: UINavigationController)
}

extension HomeCoordinator {

  func pushToNext(_ navigationController: UINavigationController) {
   
    //navigationController.pushViewController(, animated: true)
  }

}
