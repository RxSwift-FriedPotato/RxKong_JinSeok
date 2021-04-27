# 1주차

## 비동기

비동기 Operation을 작성하려고 할 때 기본적으로 쓰는 것들!

- Notification Center

- Closures
- Delegate Pattern
- Grand Central Dispatch (GCD) 

하지만 이런 것들은 복잡하고.. 경우에 따라 원하는 동작을 안할 수 있는 문제가 생깁니다...

그래서 사용하는 것이 RxSwift!

## 왜 RxSwift를 쓰는가?

- Observable한 객체의 형태로 비동기적 작업과 데이터 스트림을 쉽게 구성할 수 있게 도와줘요.

- 명시적으로 공유된 Mutable state를 알 수 있어요 = Memory
- 복잡한 Call-back에서 벗어나 버그를 줄어줘요.
- 앱을 Declarative(선언적인) 방법으로 빌드하도록 해줍니다. 
   - 이러한 방식은 어떠한 이벤트를 위한 작업에 대한 고유 데이터를 제공하여 순차적이고 결과론적인 방식을 도와줘요. 
   - Side effect 이슈를 추적가능하게 도와줘요.
- 물론 가독성과 사용성 또한 높아지겠죠!

## Observable

- Observable<T>는 T에서 발생하는 데이터 변화를 Observe 할 수 있다!
- 하나의 sequence로 비동기적으로 작동이 가능하다!
- 라이프 타임동안 값을 포함하는 next 이벤트를 발생시킨다.
- Case : next, error, completed 

    <img width="400" alt="스크린샷 2021-04-27 오후 4 00 55" src="https://user-images.githubusercontent.com/70695311/116199208-d31d7c00-a771-11eb-9e21-5e3ac98df20e.png">


<pre>
<code>

let one = 1
let two = 2
let three = 3

// MARK: - Observable 생성

let observable  = Observable<Int>.just(one) //하나의 요소를 포함하는 Sequence 생성
let observable2 = Observable.of(one,two,three) // type을 추론해 Sequence 생성
let observable3 = Observable.of([one,two,three]) // 단일요소인 Array 이용 가능
let observable4 = Observable.from([one,two,three]) // .from은 오직 Array 타입만 처리해서 사용 
let observable5 = Observable<Int>.range(start: 1, count: 10) //순차적인 요소를 갖는 Sequence 생성
 
// MARK: - Observable 생성2

Observable<String>.create { o in
   o.onNext("create")
   o.onCompleted()
   o.onError(MyError.myerror)
   return Disposables.create()   // 커스텀하게 생성 가능 
   
   }.subscribe(     //addObserver와 비슷
   onNext: {n in print(n)},
   onError: {e in print(e)},
   onCompleted: {print("completed")},
   onDisposed: {print("disposed")}
   ).disposed(by: disposeBag)
   
   //onCompete, onError, dispose 부분을 제거하면 memory leak
   
</code>
</pre>

## Disoposable

- Observable의 명시적인 중단을 위해 사용된다. 
   
- 생성한 subscription들을 하나의 DisposeBag에 넣어 효율적으로 사용하자!
- 작업이 끝난 뒤에도, 작업 도중에도 처분이 가능하다. 
- memory leak 발생 문제 해결해준다.

<pre>
<code>

// MARK: - Subscribing

_ = rxSwitch.rx.isOn.subscribe { (enabled) in
            print(enabled ? "On" : "Off")
        } onError: { (Error) in print("error")
        }.disposed(by: disposeBag)
        
_ = observable5.subscribe(onNext: { i in
            print(i)
        }) { (error) in print(error)
        } onCompleted: { print("finish")
        } onDisposed: { print("dispose")
        }.disposed(by: disposeBag)

</code>
</pre>

RxSwift 는 Rx API를 구현한 것이기 때문에 Cocoa, UIKit에 대해선 알지 못한다.
이를 사용하기 위해선 RXCocoa를 이용하자!
