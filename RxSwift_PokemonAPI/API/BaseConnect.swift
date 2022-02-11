//
//  BaseConnect.swift
//  RxSwift_PokemonAPI
//
//  Created by 小名山 on 2022/01/28.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class APIRequest {
    
    static var shared = APIRequest()
    
    private let baseUrl = "https://pokeapi.co/api/v2/"
    
    func get<T:Decodable>(path: String, prams: Parameters, type: T.Type) -> Observable<T> {
        
        return Observable.create { observer in
            let path = path
            let url = self.baseUrl + path
            let request = AF.request(url, method: .get, parameters: prams)
            request.response { response in
                let statusCode = response.response!.statusCode
                
                do {
                    /*let parsedData = try JSONSerialization.jsonObject(with: response.data!) as! [String:Any]
                    print(parsedData)*/
                    if statusCode <= 300 {
                        guard let data = response.data else { return }
                        let decode = JSONDecoder()
                        let value = try decode.decode(T.self, from: data)
                        observer.onNext(value)
                        observer.onCompleted()
                    }
                } catch {
                    print("変換に失敗しました：", error)
                    print(response.debugDescription)
                }
                switch statusCode {
                case 400:
                    print(response.description)
                case 401:
                    print(response.description)
                case 403:
                    print(response.description)
                case 404:
                    print(response.description)
                default:
                    break
                }
            }
            return Disposables.create()
        }
    }
    
    func getPokeApiResults(path: String, prams: Parameters) -> Observable<PokemonAPI> {
        return APIRequest.shared.get(path: path, prams: prams, type: PokemonAPI.self)
    }
    
    func getPokeApiData(path: String) -> Observable<Pokemon> {
        let prams: Parameters = [:]
        return APIRequest.shared.get(path: path, prams: prams, type: Pokemon.self)
    }
    
}
