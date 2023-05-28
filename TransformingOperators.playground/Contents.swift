import RxSwift

let disposeBag = DisposeBag()

// toArray
print("---- toArray ----")
Observable.of("A", "B", "C")
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)


// map
print("---- toArray ----")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// flatMap
print("---- toArray ----")
protocol 선수 {
    var 점수: BehaviorSubject<Int> { get }
}

struct 양궁선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 한국국대 = 양궁선수(점수: BehaviorSubject<Int>(value: 10))
let 미국국대 = 양궁선수(점수: BehaviorSubject<Int>(value: 8))

let 올림픽 = PublishSubject<선수>()

올림픽
    .flatMap { 선수 in
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

올림픽.onNext(한국국대)
한국국대.점수.onNext(10)

올림픽.onNext(미국국대)
한국국대.점수.onNext(10)
미국국대.점수.onNext(9)


// flatMapLatest
print("---- flatMapLatest ----")
struct 높이뛰기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 서울 = 높이뛰기선수(점수: BehaviorSubject(value: 7))
let 제주 = 높이뛰기선수(점수: BehaviorSubject(value: 6))

let 전국체전 = PublishSubject<선수>()

전국체전
    .flatMapLatest {
        $0.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

전국체전.onNext(서울)
서울.점수.onNext(9)

전국체전.onNext(제주)
서울.점수.onNext(10)
제주.점수.onNext(8)


// materialize, demeterialize
print("---- materialize and demeterialize ----")
enum 반칙: Error {
    case 부정출발
}

struct 달리기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 김토끼 = 달리기선수(점수: BehaviorSubject(value: 0))
let 박치타 = 달리기선수(점수: BehaviorSubject(value: 1))

let 달리기100M = BehaviorSubject<선수>(value: 김토끼)

달리기100M
    .flatMapLatest {
        $0.점수
            .materialize()    // 1) materialize 추가
    }
//    2) demeterialize 추가
    .filter {
        guard let error = $0.error else {
            return true
        }
        print(error)
        return false
    }
    .dematerialize()

    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

김토끼.점수.onNext(1)
김토끼.점수.onError(반칙.부정출발)
김토끼.점수.onNext(2)

달리기100M.onNext(박치타)


// 활용 예시
print("---- 전화번호 11자리 ----")
let input = PublishSubject<Int?>()

input
    .flatMap {
        $0 == nil ? Observable.empty() : Observable.just($0)
    }
    .map { $0! }
    .skip(while: { $0 != 0 })
    .take(11)
    .toArray()
    .asObservable()
    .map {
        $0.map { "\($0)" }
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3)
        numberList.insert("-", at: 8)
        let number = numberList.reduce("전화번호: ", +)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(3)
input.onNext(nil)
input.onNext(1)
input.onNext(8)
input.onNext(9)
input.onNext(4)
input.onNext(9)
input.onNext(4)
