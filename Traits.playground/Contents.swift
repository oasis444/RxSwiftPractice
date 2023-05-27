import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}


// single_1
print("---- single_1 ----")
Single<String>.just("✅")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)


// single_2
print("---- single_2 ----")
Observable<String>
    .create { observer -> Disposable in
        observer.onError(TraitsError.single)
        return Disposables.create()
    }
    .asSingle()
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)


// single_3
print("---- single_3 ----")

struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name": "han"}
    """

let json2 = """
    {"my_name": "han"}
    """

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data)
        else {
            observer(.failure(JSONError.decodingError))
            return Disposables.create()
        }
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    .disposed(by: disposeBag)


// Maybe_1
print("---- Maybe_1 ----")
Maybe<String>.just("✅")
    .subscribe {
        print($0)
    } onError: {
        print($0)
    } onCompleted: {
        print("completed")
    } onDisposed: {
        print("disposed")
    }
    .disposed(by: disposeBag)


// Maybe_2
print("---- Maybe_2 ----")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe {
    print("성공: \($0)")
} onError: {
    print("에러: \($0.localizedDescription)")
} onCompleted: {
    print("completed")
} onDisposed: {
    print("disposed")
}


// Completable_1
print("---- Completable_1 ----")
Completable.create { observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe {
    print("completed")
} onError: {
    print("error: \($0)")
} onDisposed: {
    print("disposed")
}
.disposed(by: disposeBag)


// Completable_2
print("---- Completable_2 ----")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

