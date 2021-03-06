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
        //구독한 뒤 observable이 보내는 이벤트 받음
        let user = PublishSubject<User>()
        let id = PublishSubject<String>()
        let password = PublishSubject<String>()
        let tapSignIn = PublishSubject<Void>()
    }
    
    struct Output {
        //Relay : dispose 전까지 계속 작동하기 때문에 UI Event에 사용 적절
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
