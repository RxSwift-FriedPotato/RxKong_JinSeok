//
//  ObservablesTestVC.swift
//  RXSwift_Practice1
//
//  Created by 홍진석 on 2021/04/26.
//

import UIKit
import RxSwift
import RxCocoa

enum MyError : Error{
    case myerror
}
class ObservablesTestVC: UIViewController {
    let one = 1
    let two = 2
    let three = 3
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var rxSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Observable 생성
        let _ : Observable<Int> = Observable<Int>.just(one)
        let observable2 = Observable.of(one,two,three)
        _ = Observable.of([one,two,three])
        _ = Observable.from([one,two,three])
        let observable5 = Observable<Int>.range(start: 1, count: 10)
        
        _ = rxSwitch.rx.isOn.subscribe { (enabled) in
            print(enabled ? "On" : "Off")
        } onError: { (Error) in
            print("error")
        }.disposed(by: disposeBag)
        
        _ = observable2.subscribe { (element) in
            print(element)
        } onError: { (Error) in
            print(Error)
        } onCompleted: {
            print("finish")
        } onDisposed: {
            print("onDisposed")
        }.disposed(by: disposeBag)
        
        _ = observable5.subscribe(onNext: { i in
            print(i)
        }) { (error) in
            print(error)
        } onCompleted: {
            print("finish")
        } onDisposed: {
            print("dispose")
        }.disposed(by: disposeBag)

        //Observables 생성 2
        Observable<String>.create { observer in
            observer.onNext("create")
            observer.onCompleted()
            observer.onError(MyError.myerror)
            observer.onNext("?")//당연히 발생x
            
            return Disposables.create()
        }.subscribe(
            onNext: { n in print(n)},
            onError: {e in print(e)},
            onCompleted: {print("completed")},
            onDisposed: {print("disposed")}
        ).disposed(by: disposeBag)
        //onCompete, onError, dispose 부분을 제거하면 memory leak
    }
}
