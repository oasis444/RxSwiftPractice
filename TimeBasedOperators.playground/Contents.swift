import RxSwift
import RxCocoa
import PlaygroundSupport
import Foundation
import UIKit

let disposeBag = DisposeBag()


// replay
print("----------replay----------")
let 인사말 = PublishSubject<String>()

let 앵무새🦜 = 인사말.replay(1)
앵무새🦜.connect()
인사말.onNext("1. hello")
인사말.onNext("2. hi")
앵무새🦜
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
인사말.onNext("3. 안녕하세요")


// replayAll
print("----------replayAll----------")
let 닥터스트레인지 = PublishSubject<String>()
let 타임스톤 = 닥터스트레인지.replayAll()
타임스톤.connect()

닥터스트레인지.onNext("도르마무")
닥터스트레인지.onNext("거래를 하러왔다")

타임스톤
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// buffer
print("----------buffer----------")
let source = PublishSubject<String>()

var count = 0
let timer = DispatchSource.makeTimerSource()
timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
timer.setEventHandler {
    count += 1
    source.onNext("\(count)")
}
timer.resume()

source
    .buffer(
        timeSpan: .seconds(2),
        count: 2,
        scheduler: MainScheduler.instance
    )
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// window
print("----------window----------")
let 만들어낼최대Observable수 = 1
let 만들시간 = RxTimeInterval.seconds(2)

let window = PublishSubject<String>()

var windowCount = 0
let windowTimerSource = DispatchSource.makeTimerSource()
windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
windowTimerSource.setEventHandler {
    windowCount += 1
    window.onNext("\(delayCount)")
}
windowTimerSource.resume()

window
    .window(
        timeSpan: 만들시간,
        count: 만들어낼최대Observable수,
        scheduler: MainScheduler.instance
    )
    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
        return windowObservable.enumerated()
    }
    .subscribe(onNext: {
        print("\($0.index)번째 Observable의 요소 \($0.element)")
    })
    .disposed(by: disposeBag)


// delaySubscription
print("----------delaySubscription----------")
let delaySource = PublishSubject<String>()

var delayCount = 0
let delayTimerSource = DispatchSource.makeTimerSource()
delayTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
delayTimerSource.setEventHandler {
    delayCount += 1
    delaySource.onNext("\(delayCount)")
}
delayTimerSource.resume()

delaySource
    .delaySubscription(.seconds(2), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// delay
print("----------delay----------")
let delaySubject = PublishSubject<Int>()

var delaySubjectCount = 0
let delaySubjectTimerSource = DispatchSource.makeTimerSource()
delaySubjectTimerSource.schedule(deadline: .now(), repeating: .seconds(1))
delaySubjectTimerSource.setEventHandler {
    delaySubjectCount += 1
    delaySubject.onNext(delaySubjectCount)
}
delaySubjectTimerSource.resume()

delaySubject
    .delay(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// interval
print("----------interval----------")
Observable<Int>
    .interval(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// timer
print("----------timer----------")
Observable<Int>
    .timer(
        .seconds(5),    // 구독 시작 딜레이
        period: .seconds(2),    // 간격
        scheduler: MainScheduler.instance
    )
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// timeout
print("----------timeout----------")
let 누르지않으면에러 = UIButton(type: .system)
누르지않으면에러.setTitle("눌러주세요!", for: .normal)
누르지않으면에러.sizeToFit()

PlaygroundPage.current.liveView = 누르지않으면에러

누르지않으면에러.rx.tap
    .do(onNext: {
        print("tap")
    })
    .timeout(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
