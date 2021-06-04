//
//  LoginVC.swift
//  RxSwfit_Practice
//
//  Created by 홍진석 on 2021/05/28.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController{
    var coordinator : SignCoordinator?
    
    @IBOutlet weak var id_TextField: UITextField!
    @IBOutlet weak var pwd_TextField: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!

    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    
    static func instance() -> LoginVC {
        return LoginVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        // Bind input
        id_TextField.rx.text.orEmpty
            .bind(to: viewModel.input.id)
            .disposed(by: disposeBag)
        pwd_TextField.rx.text.orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        signinBtn.rx.tap
            .bind(to: viewModel.input.tapSignIn)
            .disposed(by: disposeBag)
        
        // Bind output
        viewModel.output.enableSignInButton
            .observe(on: MainScheduler.instance)
            .bind(to: signinBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showError)
            .disposed(by: disposeBag)
        viewModel.output.goToMain
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToMain)
            .disposed(by: disposeBag)
    }
    
    private func showError(message : String){
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                        alert.addAction(.init(title: "확인", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func goToMain() {
        coordinator = SignCoordinator.init(nav: navigationController!)
        coordinator?.move()
//        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//            guard let main = storyboard?.instantiateViewController(withIdentifier: "mainVC") as? mainVC else { return }
//            sceneDelegate.window?.rootViewController = main
//        }
    }
}
