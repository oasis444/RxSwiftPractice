import RxSwift

let disposeBag = DisposeBag()

// ignoreElements
print("---- ignoreElements ----")
let 취침모드😪 = PublishSubject<String>()

취침모드😪
    .ignoreElements()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

취침모드😪.onNext("알람")
취침모드😪.onNext("알람")
취침모드😪.on(.next("알람"))
취침모드😪.onCompleted()


// elementAt
print("---- elementAt ----")
let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2) // 해당 index의 요소만 방출
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("알람")
두번울면깨는사람.onNext("알람")
두번울면깨는사람.onNext("pause")
두번울면깨는사람.onNext("알람")


// filter
print("---- filter ----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// skip
print("---- skip ----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// skipWhile
print("---- skipWhile ----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .skip(while: {
        $0 != 5
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// skipUntil
print("---- skipUntil ----")
let 손님 = PublishSubject<String>()
let 오픈시간 = PublishSubject<String>()

손님  // 현재 Observable
    .skip(until: 오픈시간)  // 다른 Observable
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손님.onNext("😪")
손님.onNext("😪")

오픈시간.onNext("오픈!")
손님.onNext("😄")


// take
print("---- take ----")
Observable.of("❤️", "🤍", "💚", "🤎", "💜", "💙")
    .take(3)        // skip의 반대 개념
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// takeWhile
print("---- takeWhile ----")
Observable.of("❤️", "🤍", "💚", "🤎", "💜", "💙")
    .take(while: {
        $0 != "🤎"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// enumerated
print("---- enumerated ----")
Observable.of("❤️", "🤍", "💚", "🤎", "💜", "💙")
    .enumerated()   // 방출된 요소의 index를 알고 싶을 때 사용
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// takeUntil
print("---- takeUntil ----")
let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()

수강신청
    .take(until: 신청마감)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

수강신청.onNext("신청1")
수강신청.on(.next("신청2"))

신청마감.onNext("끝!")
수강신청.on(.next("신청3"))


// distinctUntilChanged
print("---- distinctUntilChanged ----")
Observable.of("RxSwift", "안녕하세요", "저는", "앵무새", "입니다", "앵무새", "앵무새", "앵무새", "앵무새", "저는", "입니다", "입니다", "안녕하세요", "RxSwift", "RxSwift")
    .distinctUntilChanged() // 연속적으로 같은 값 방출될 때 필터링
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
