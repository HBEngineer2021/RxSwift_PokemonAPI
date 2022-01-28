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
   
   private let baseUrl = "https://pokeapi.co/api/v2/pokemon/"
   
   func get<T:Decodable>(path: String, prams: Parameters, type: T.Type, completion: @escaping (T) -> Void) -> Observable<T> {
       
       return Observable<T>.create { observer in
           let path = path
           let url = self.baseUrl + path
           
           let request = AF.request(url, method: .get, parameters: prams)
           request.response { response in
               let statusCode = response.response!.statusCode
               
               do {
                   if statusCode <= 300 {
                       guard let data = response.data else { return }
                       
                       let decode = JSONDecoder()
                       let value = try decode.decode(T.self, from: data)
                       completion(value)
                       observer.onNext(value)
                   }
               } catch {
                   print("変換に失敗しました：", error)
                   print(response.debugDescription)
                   observer.onError(error)
               }
               observer.onCompleted()
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
           return Disposables.create { request.cancel() }
       }
   }
}
