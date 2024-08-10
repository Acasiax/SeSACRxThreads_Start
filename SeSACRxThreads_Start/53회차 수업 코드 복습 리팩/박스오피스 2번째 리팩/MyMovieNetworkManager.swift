//
//  MyMovieNetworkManager.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/10/24.
//

import Foundation
import RxSwift

enum YunjiAPIError: Error {
    case invalidURL //주소가 잘못
    case unknownResponse // 알 수 없는 응답이 반환될 때 발생하는 오류
    case statusError //응답 범위를 벗어났을 때
}

final class MyMovieNetworkManager {
    static let shared = MyMovieNetworkManager()
    
    private init() {}
    
    func callBoxOffice(date: String) -> Observable<Movie> {
        
        let api = APIKey.movieKey
        
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(api)&targetDt=\(date)"
       
        
        //MARK: - 옵져버블 생성
        
        let result = Observable<Movie>.create { observer in
            
            guard let url = URL(string: url) else {
                observer.onError(YunjiAPIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    observer.onError(YunjiAPIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                    observer.onError(YunjiAPIError.statusError)
                    return
                }
                
                if let data = data,
                   let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted() //중요🔥
                } else {
                    print("응답이 왔으나 실패")
                    observer.onError(YunjiAPIError.unknownResponse)
                }
  
            }.resume()
            
            return Disposables.create()
            
        }.debug("윤지 조회")
        
        return result
    }
}
