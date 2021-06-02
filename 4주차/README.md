# 4주차

## Single

- 파일 저장, 다운로드, 네트워크 통신, 디스크에 데이터 로드 등에 좋겠네. 성공실패 분기처리시에 + 기본 값  
```swift
func getRepo(_ repo: String) -> Single<[String: Any]> {
    return Single<[String: Any]>.create { single in
        let task = URLSession.shared.dataTask(with: URL(string: "https://api.github.com/repos/\(repo)")!) { data, _, error in
            if let error = error {
                single(.error(error))
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                  let result = json as? [String: Any] else {
                single(.error(DataError.cantParseJSON))
                return
            }

            single(.success(result))
        }

        task.resume()

        return Disposables.create { task.cancel() }
    }
}

// Alamofire 라이브러리 사용 예제
extension NetworkManager {
    func request<T: BaseResponseModelable>(_ url: Alamofire.URLConvertible, method: Alamofire.HTTPMethod, parameters: Alamofire.Parameters?, headers: Alamofire.HTTPHeaders?) -> Single<T> {
        return Single<T>.create { (single) -> Disposable in
            let request = self.sendRequest(url, method: method, parameters: parameters, headers: headers, handler: { (result: Result<T>) in
                switch result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    single(.error(error))
                }
            })
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
```


Traits는 observable sequence에 대한 빌더 패턴 구현의 일종.
Trait가 만들어지면, asObservable()을 호출하면 그것을 흔한 Observable sequence로 다시 변환
    .success(value) 는 .next + .completed
Observable -> Single, Maybe 변환 가능 Completable 불가능

## Completable

- completed, error 두 가지 이벤트를 방출할 수 있다.
- 아무 element도 방출하지 않기에 단순 완료 여부만 알고 싶을때 써요.
- 언제써야할까? - 완료에 따른 요소에 신경쓰지 않는 경우에 유용
- Completable로 시퀀스 형 변환이 필요할 때는 .ignoreElements( )를 이용하자. 

```swift
func completable() -> Completable {
    return Completable.create { completable in 
    // Store some data locally
    
        guard success else { 
            completable(.error(CacheError.failedCaching)) 
            return Disposables.create {} 
            } 
    
        completable(.completed)     
    
        return Disposables.create {} 
    } 
} 

completable().subscribe(
    onCompleted: { print("Completed with no error") 
    }, 
    
    onError: { error in print("Completed with an error: \(error.localizedDescription)") 
    } 
).disposed(by: disposeBag)

//사용법
getRepo("ReactiveX/RxSwift")
    .subscribe { event in
        switch event {
            case .success(let json):
                print("JSON: ", json)
            case .error(let error):
                print("Error: ", error)
        }
    }
    .disposed(by: disposeBag)
```

## Maybe

- success(value), completed, error 3가지 이벤트를 방출할 수 있다. 
- Signle, Completable 사이에 있는 Observable의 변형
        - element를 방출 할 수 있다. -> Single의 특징
        - element를 방출하지 않고 완료(성공)할 수 있다. -> Completable의 특징 
- 0 또는 1개의 element를 포함하는 Observable sequence
- single과 달리 방출없이 완료가 가능하다. 

```swift
func maybe() -> Maybe<String> {
    return Maybe<String>.create { maybe in 
        maybe(.success("RxSwift")) 
        // or
        maybe(.completed) 
        // or 
        maybe(.error(error)) 
        
        return Disposables.create {} 
        } 
} 

maybe().subscribe( 
    onSuccess: { 
        element in print("Completed with element \(element)") 
    }, 
    onError: { error in print("Completed with an error \(error.localizedDescription)") 
    }, 
    onCompleted: { print("Completed with no element") 
} ).disposed(by: disposeBag
```




- Observable, Observer의 역할을 모두 할 수 있어요.
- 다만 차이는 **multicast** 방식으로 여러개의 observer를 subscribe 할 수 있습니다. 
    - <-> Observable은 unicast 방식 (https://gist.github.com/sujinnaljin/dd5783fe5297cf0943d79a5076f98c02 참고)

## Subject VS Observable

| Observable | Subject |
| ------ | ------ |
| 함수, state X | state O, data를 메모리에 저장 |
| 각각의 옵저버에 대해 코드가 실행| 같은 코드 실행, 모든 옵저버에 대해 오직 한번만 |
| Data Producer | Date Producer and Consumer |
| 용도 : 간단한 하나의 옵저버가 필요할 때 | 용도 : 데이터가 자주 바뀔때, 옵저버와 옵저버 사이의 Proxy 역할 |

추가적으로 Subject는 ObserverType를 따르고 있어 바로 on 함수를 구현 가능하다. 
Observable, Observer들 간의 interaction, 유연성있는 코드도 가능하겠네요.

## PublishSubject

- Broadcasts new events to all observers as of their time of the subscription.
- 구독된 시점 이후의 이벤트만 Observer에게 전달해요.
- 기본적인 형태의 Subject으로 제네릭 타입으로 사용이 가능해요.
- dispose, error, completed 이후로는 이벤트를 방출하지 않아요.
 
 ```swift
 // MARK: - PublishSubject

let psubject = PublishSubject<String>() //비어있는 상태
psubject.onNext("First") 

psubject.subscribe{ event in
    print(event)
}

psubject.onNext("Second")
psubject.onNext("Third")
 
//next(Second)
//next(Third)
//completed
 
```
## BehaviorSubject

- Broadcasts new events to all subscribers, and the most recent (or initial) value to new subscribers.
- PublisherSubject 와 달리 반드시 **초기화** 를 해줘야해요. 
- 최신 이벤트가 기본값으로 지정됩니다.
- 기본값을 갖기 때문에 구독하자마자 onNext로 이벤트를 전달해줘요.

```swift

let bsubject = BehaviorSubject(value: "Initial value")

bsubject.onNext("Second Value")

bsubject.subscribe { event in
    print(event)
}

bsubject.onNext("Last value")

// 어떻게 출력될까요?

```

## ReplaySubject

- Broadcasts new events to all subscribers, and the specified bufferSize number of previous events to new subscribers.
- 미리 사이즈를 정해줘야해요. - 몇 개의 기본값?을 가질지 지정
- 메모리 관리를 신경쓰지 않으려면 createUnbounded 로 설정해줄 수 있긴해요. - 조심!
- 버퍼사이즈에 따라 나중 이벤트들부터 방출됩니다. 

```swift

let rsubject = ReplaySubject<String>.create(bufferSize : 3) //버퍼사이즈를 바꾼다면?

rsubject.onNext("First")
rsubject.onNext("Second")
rsubject.onNext("Third")

rsubject.subscribe { event in
    print(event)
}//.dispose()를 넣는다면?

rsubject.onNext("Fourth")

// 어떻게 출력될까요?

```
## AsyncSubject

- 다른 Subject와 달리 이벤트를 전달하는 시점이 달라요.
- completed 이벤트가 전달되기 전까진 어떠한 이벤트도 전달하지 않아요.(<-> 다른 것들은 방출하면 바로 전달하죠.)
- completed되면 그 시점에서 가장 최근 이벤트 하나만 next로 전달해요.

```swift
let asubject = AsyncSubject<Int>()
asubject.onNext(1)
asubject.onNext(2)
asubject.onNext(3)
asubject.onCompleted()
aSubject.subscribe({event in
                    print(event)

})
asubject.onNext(4)
asubject.onNext(5)
```


## BehaviorRelay

- RxCocoa를 이용합니다,
- deprecated된 Vairable을 대신해서 사용할 수 있다 하네요.
- onNext 대신 accept를 사용합니다, (subject와는 달라요.)
- next만 전달하고 error, completed는 전달하지 않아요.
- subscribe를 하고 싶다면 .asObservable()를 이용해요.

```swift

var BR = BehaviorRelay(value: "")
var observable : Observable<String>{
    return BR.asObservable()
}

BR.accept("event")
```
