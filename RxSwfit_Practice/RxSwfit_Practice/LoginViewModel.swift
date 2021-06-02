//
//  File.swift
//  RxSwfit_Practice
//
//  Created by 홍진석 on 2021/05/28.
//

import Foundation

import RxSwift
import RxCocoa

class LoginViewModel : NSObject{
    
    let disposeBag = DisposeBag()
    let input = Input()
    let output = Output()
    
    struct Input {
        let id = PublishSubject<String>()
        let password = PublishSubject<String>()
        let tapSignIn = PublishSubject<Void>()
    }
    
    struct Output {
        let enableSignInButton = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        let goToMain = PublishRelay<Void>()
    }

    override init() {
        super.init()
        
        Observable.combineLatest(input.id, input.password)
            .map{ !$0.0.isEmpty && !$0.1.isEmpty }
            .bind(to: output.enableSignInButton)
            .disposed(by: disposeBag)
        
        input.tapSignIn.withLatestFrom(Observable.combineLatest(input.id, input.password)).bind { [weak self] (email, password) in
            guard let self = self else { return }
            if password.count < 6 {
                self.output.errorMessage.accept("6자리 이상 비밀번호를 입력해주세요.")
            } else {
                // API로직을 태워야합니다.
                self.output.goToMain.accept(())
            }
        }.disposed(by: disposeBag)
    }
}
