import Foundation
import RxSwift

let disposeBag = DisposeBag() // Combine의 Set<AnyCancellable>()과 비슷함

// just
print("---- just ----")
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })


// of_1
print("---- of_1 ----")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext: {
        print($0)
    })


// of_2
print("---- of_2 ----")
Observable.of([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })


// from
print("---- from ----")
Observable.from([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })


// subscribe_1
print("---- subscribe_1 ----")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }


// subscribe_2
print("---- subscribe_2 ----")
Observable.of(1, 2, 3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }


// subscribe_3
print("---- subscribe_3 ----")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })


// empty
print("---- empty ----")
Observable<Void>.empty()
    .subscribe {
        print($0)
    }


// never
print("---- never ----")
Observable.never()
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("completed")
        }
    )


// range
print("---- range ----")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2 * \($0) = \(2 * $0)")
    })


// dispose
print("---- dispose ----")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })
    .dispose()


// disposeBag
print("---- disposeBag ----")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// create_1
print("---- create_1 ----")
Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe {
    print($0)
}
.dispose()


// create_2
print("---- create_2 ----")
enum MyError: Error {
    case anError
}

Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(
    onNext: {
        print($0)
    },
    onError: {
        print($0.localizedDescription)
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)


// deferred_1
print("---- deferred_1 ----")
Observable.deferred {
    Observable.of(1, 2, 3)
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)


// deferred_2
print("---- deferred_2 ----")
var 뒤집기: Bool = false
let factory: Observable<String> = Observable.deferred {
    뒤집기 = !뒤집기
    if 뒤집기 {
        return Observable.of("앞")
    } else {
        return Observable.of("뒤")
    }
}

for _ in 0...3 {
    factory.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
}
