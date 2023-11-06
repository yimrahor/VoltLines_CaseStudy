//
//  APIService.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import Foundation
import Alamofire
import UIKit

class APIService {
    static let call = APIService()
    
    func objectRequestJSON<T: Decodable>(url: String, responseType: T.Type, complete: @escaping (Result<T,Error>)->Void) {
        
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
                case .success(let data):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let decodedData = try JSONDecoder().decode(T.self,from: jsonData)
                        complete(.success(decodedData))
                    } catch {
                        complete(.failure(error))
                    }
                case .failure(let err):
                        complete(.failure(err))
                }
        }
    }
    
    func objectPostRequest<T: Decodable>(url: String, responseType: T.Type, complete: @escaping (Bool)->Void) {
        
        AF.request(url, method: .post, encoding: URLEncoding.default).responseJSON { response in
            if response.response?.statusCode == 200 {
                complete(true)
            } else if response.response?.statusCode == 400 {
                complete(false)
            } else {
                    complete(true)
            }
        }
    }
}
