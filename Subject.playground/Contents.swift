import RxSwift

let disposeBag = DisposeBag()


// PublishSubject
print("---- publishSubject ----")
let publishSubject = PublishSubject<String>() // ---> Combine의 PassthroughSubject와 비슷함

publishSubject.onNext("1. Hello World")

let 구독자1 = publishSubject
    .subscribe(onNext: {
        print("첫 번째 구독자: \($0)")
    })

publishSubject.onNext("2. good")
publishSubject.on(.next("3. nice"))

구독자1.dispose()

let 구독자2 = publishSubject
    .subscribe(onNext: {
        print("두 번째 구독자: \($0)")
    })

publishSubject.onNext("4. Any?")
publishSubject.onCompleted()

publishSubject.onNext("5. END")

구독자2.dispose()

publishSubject
    .subscribe {
        print("세 번째 구독자:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

publishSubject.onNext("6. One more?")


// BehaviorSubject
print("---- BehaviorSubject ----")
enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "초기값") // ---> Combine의 CurrentValueSubject와 비슷

behaviorSubject.onNext("1. 첫 번째 값")

behaviorSubject.subscribe {
    print("첫 번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

//behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("두 번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

let value = try? behaviorSubject.value()
print(value)


// ReplaySubject
print("---- ReplaySubject ----")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1. Hello")
replaySubject.onNext("2. World")
replaySubject.onNext("3. Welcome")

replaySubject.subscribe {
    print("첫 번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe {
    print("두 번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("Do It")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe {
    print("세 번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)
