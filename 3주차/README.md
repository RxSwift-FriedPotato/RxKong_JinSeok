# 3주차

## Operators란?
- 쉽게 Observable을 생성하고 변형하고 합치는 등 다양하게 연산을 할 수 있도록 도와주는 역할을 합니다.
- 엄청나게 많은 [Operators](http://reactivex.io/documentation/ko/operators.html)가 존재
- 저번 스터디에 이어서 학습한 Operators를 복습하고 몇 가지 Operators를 더 알아보자.

## just
- 하나의 element를 observable로 만드는 역할
- 넣으면 한번에 다음번으로 그대로 출력

```swift
func exJust1() {
        Observable.just("Hello World")
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)//complete-> disposableBag에서 사라짐
    }
```

출력결과는 ?
```swift
Hello World
//배열을 넣는다면 배열 자체가 그대로 한번에 출력
```

## from
- array, dictionary, set 등의 자료구조화 된 형태를 observable sequence로 만드는 역할
- 한개씩 다음번으로 출력

* Of는 from과 비슷하지만 같은 타입의 여러개의 parameter받을 수 있다.

```swift
func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }
```

출력결과는 ?
```swift
RxSwift
In
4
Hours
```

## map
- 위에서 내려온 데이터를 가공하는 역할
- 전달되어 온 인자들을 매핑하여 출력

```swift
func exMap1() {
    print("\nexMap1()")
    Observable.just("Hello")
        .map { str in "\(str) RxSwift" }
        .subscribe(onNext: { str in
            print(str)
        })
        .disposed(by: disposeBag)
}
```
출력결과는 ? 
```swift
exMap1()
Hello RxSwift
```

```swift
func exMap2() {
    print("\nexMap2()")
    Observable.from(["with", "곰튀김"])
        .map { $0.count }
        .subscribe(onNext: { str in
            print(str)
        })
        .disposed(by: disposeBag)
}
```
출력결과는 ? 
```swift
exMap2()
4
3
```

## filter
- 위에서 내려온 데이터를 선별하는 역할
- 필터해서 출력
```swift
func exFilter() {
    print("\nexFilter()")
    Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        .filter { $0 % 2 == 0 }
        .subscribe(onNext: { n in
            print(n)
        })
        .disposed(by: disposeBag)
}
```
출력결과는?
```swift
exFilter()
2
4
6
8
10
```

## Range    
- 정해진 범위에 따른 Integer를 방출해줘요.

```swift
let disposeBag = DisposeBag()

Observable.range(start: 1, count: 3).subscribe { 

    print($0) 
    
}.disposed(by: disposeBag)

// --- 출력 ---
// next(1)
// next(2)
// next(3)
// complete
```

## Flatmap
- 이전에 배운 map과 같은 Transforming Operators에요.
- Observable안에 또 다른 Observable이 있는 경우 새로운 Observable를 만들 때 사용해요.
- 여러 개의 Observable Sequence로 만들어진 하나의 Observable Sequence로 만들어 방출해요.

```swift
let disposeBag = DisposeBag()
let sequence1  = Observable<Int>.of(1,2)
let sequence2  = Observable<Int>.of(1,2)

let usingFlatMap = Observable.of(sequence1,sequence2)

usingFlatMap.flatMap{ 

    return $0 
    
}.subscribe(onNext:{

    print($0)
    
}).disposed(by: disposeBag)

// --- 출력 ---
// 1
// 2
// 1
// 2
```
