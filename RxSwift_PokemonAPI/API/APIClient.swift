//
//  APIClient.swift
//  RxSwift_PokemonAPI
//
//  Created by Motoki Onayama on 2022/01/27.
//

import Foundation
import Alamofire
import RxSwift

struct APIClient {
    
    // MARK: Private Static Variables
    private static let successRange = 200..<400
    private static let contentType = ["application/json"]
    
    
    // MARK: Static Methods
    
    // 実際に呼び出すのはこれだけ。（rxを隠蔽化しているだけなので、observeでも大丈夫）
    static func call<T, V>(_ request: T, _ disposeBag: DisposeBag, onSuccess: @escaping (V) -> Void, onError: @escaping (Error) -> Void)
    where T: APIBaseRequestProtocol, T.ResponseType == V {
        
        _ = observe(request)
            .observe(on: MainScheduler.instance) // mainを指定してしまっているので消しても良い
            .subscribe(onSuccess: { onSuccess($0) },
                       onFailure: { onError($0) })
            .disposed(by: disposeBag)
    }
    
    // RxSwiftを導入している部分。成功/失敗いずれかしか返らないSingleにしてある。
    static func observe<T, V>(_ request: T) -> Single<V>
    where T: APIBaseRequestProtocol, T.ResponseType == V {
        
        return Single<V>.create { observer in
            let calling = callForData(request) { response in
                switch response {
                //※ 既にsuccessしているので「as! V」で強制キャストしている（できる）
                case .success(let result): observer(.success(result as! V))
                case .failure(let error): observer(.failure(error))
                }
            }
            
            return Disposables.create() { calling.cancel() }
        }
    }
    
    // Alamofire呼び出し部分
    private static func callForData<T, V>(_ request: T, completion: @escaping (APIResult) -> Void) -> DataRequest
    where T: APIBaseRequestProtocol, T.ResponseType == V {
        
        return AF.request(request).responseJSON { response in
            switch response.result {
            case .success(let data): completion(.success(data as! Decodable))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    // Alamofireのメソッドのみ切り出した部分
    private static func request<T>(_ request: T) -> DataRequest
    where T: APIBaseRequestProtocol {
        
        return AF
            .request(request)
            .validate(statusCode: successRange)
            .validate(contentType: contentType)
    }
}
