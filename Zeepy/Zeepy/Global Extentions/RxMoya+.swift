//
//  RxMoya+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/10.
//

import Foundation
import RxSwift
import Moya
import CoreData
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
  static let authProvider = MoyaProvider<AuthRouter>(plugins: [NetworkLoggerPlugin()])
  
  public func filter401StatusCode() -> Single<Element> {
    return flatMap { response in
      guard response.statusCode != 401 else {
        throw MoyaError.statusCode(response)
      }
      return .just(response)
    }
  }
  public func filter500StatusCode() -> Single<Element> {
    return flatMap { response in
      guard response.statusCode != 500 else {
        MessageAlertView.shared.showAlertView(title: "서버 에러입니다.", grantMessage: "확인")
        throw MoyaError.statusCode(response)
      }
      return .just(response)
    }
  }
  /// Response 타입의 Single을 Result 타입의 Observable로 변경하는 함수입니다.
  /// - Result Error 는 APIError입니다.
  public func filterError() -> Observable<Result<Response , APIError>> {
    return self
      .asObservable()
      .map{ response -> Result<Response , APIError> in
        switch response.statusCode {
        case 200...300 :
          return .success(response)
        case 400 :
          return .failure(.badrequest)
        case 401 :
          return .failure(.auth)
        case 404 :
          return .failure(.notfound)
        case 500 :
          return .failure(.server)
        default :
          return .failure(.error("에러"))
        }
      }
  }
  
  public func filterErrorResponse(statusCode: Int, msg: String? = nil, description: String) -> Single<Element> where Trait == SingleTrait, Element == Response {
    return self
      .flatMap { response in
        let containStatusCode: Bool = response.statusCode == statusCode
        let containMsg: Bool = {
          guard let msg = msg else { return true }
          if let json = try? response.mapJSON() as? [String: Any],
             let errorMsg = json.first(where: { $0.key == "message" })?.value as? String, errorMsg == msg {
            return true
          }
          return false
        }()
        if containStatusCode && containMsg {
          let error = NSError(domain: response.request?.url?.absoluteString ?? "UnknownURL",
                              code: response.statusCode,
                              userInfo: ["errorDescription": description])
          return .error(error)
        } else {
          return .just(response)
        }
      }
  }
  //통신 성공여부만 필요한 경우
  public func successFlag() -> Single<Bool> {
    return flatMap { response in
      guard (200...300).contains(response.statusCode) else {
        return .just(false)
      }
      return .just(true)
    }
  }
  public func retryWithAuthIfNeeded() -> Single<Response> {
    // 둘다 없으면 로그아웃하고 Error
    if UserDefaultHandler.accessToken == nil && UserDefaultHandler.refreshToken == nil {
      LoginManager.shared.makeLogoutStatus()
      return Single.error(AuthError.notLogin)
    }
    else {
      return retryWhen{ error in
        Observable.zip(error,
                       Observable.range(start:1, count:1),
                       resultSelector: { $1 })
          .debug()
          .flatMap{ _ -> Single<AuthResponse> in
            guard
              let refreshToken = UserDefaultHandler.refreshToken,
              let accessToken = UserDefaultHandler.accessToken
            else { return Single.error(AuthError.notLogin)}
            
            return PrimitiveSequence<Trait, Element>
              .authProvider.rx.request(.refreshToken(param:RefreshRequest(accessToken: accessToken,
                                                                          refreshToke: refreshToken)))
              .filterSuccessfulStatusAndRedirectCodes()
              .map(AuthResponse.self)
              .catchError{ error in
                if case MoyaError.statusCode(let response) = error {
                  if response.statusCode == 401 {
                    UserDefaultHelper<Any>.clearAll()
                  }
                }
                return Single.error(error)
              }
              .flatMap({token -> Single<AuthResponse> in
                LoginManager.shared.makeLoginStatus(accessToken: token.accessToken, refreshToken: token.refreshToken)
                return Single.just(token)
              })
          }
      }
    }
  }
}
public enum AuthError: Error {
  case notLogin
}
public enum APIError: Error , Equatable {
  case badrequest
  case auth
  case notfound
  case server
  case error(String)
  
  var message: String {
    switch self {
    case .error(let msg):
      return msg
    case .auth:
      return "권한 오류"
    case .notfound:
      return "리스폰스 오류"
    case .server:
      return "서버 오류"
    case .badrequest:
      return "리퀘스트 오류"
      
    }
  }
  
}
extension Observable where  Element == Result<Response, APIError> {
  /// Result 타입의 Response 형태일 때 Decodable한 형태로 매핑해주는 함수입니다.
  /// - Error 액션들을 prifix된 액션들로 사용하는 함수입니다.
  /// - ObservableType 매핑과 비슷한 형태로 사용할 수 있습니다.
  /// Error 타입과 기본 함수는 다음과 같습니다.
  /// - auth : 로그아웃 후 로그인 창으로 이동하는 alertview를 띄운다
  /// - badrequest : error메시지를 프린트
  /// - badrequest : error메시지를 프린트
  /// - notfound : error메시지를 프린트
  /// - server : 서버 에러 발생 알림을 띄운다.
  /// - error(String) : 기타 에러이므로, 에러 디스크립션과 메시지를 프린트
  
  public func map<D> (_ type: D.Type, atKeyPath keyPath: String? = nil) -> Observable<D> where D : Decodable{
    return self
      .flatMapLatest{ result -> Observable<D> in
        switch result {
        case .success(let res):
          if let mapped = try? res.map(D.self, atKeyPath: keyPath) {
            return Observable<D>.just(mapped)
          }
          else {
            return .empty()
          }
        case .failure(let err):
          switch err {
          case .auth :
            LoginManager.shared.sendLogInPage()
          case .badrequest:
            print(err.message)
          case .notfound:
            print(err.message)
          case .server:
            MessageAlertView.shared.showAlertView(title: "서버 에러가 발생했습니다.", grantMessage:"확인", okAction: nil)
          case .error(_):
            print(err.localizedDescription)
            #if DEBUG
            MessageAlertView.shared.showAlertView(title: err.errorDescription, grantMessage:"확인", okAction: nil)
            #endif
            print(err.message)
            
          }
          return .empty()
        }
      }
    
  }
  public func mapResult<D> (_ type: D.Type, atKeyPath keyPath: String? = nil) -> Observable<Result<D, APIError>> where D : Decodable{
    return self
      .map{result in
        result.map{try! $0.map(D.self)}
      }
  }
  public typealias errAction = () -> Void
  /// Result 타입의 Response 형태일 때 Decodable한 형태로 매핑해주는 함수입니다.
  /// - Error 액션들을 prifix된 액션들로 사용하는 함수입니다.
  /// - ObservableType 매핑과 비슷한 형태로 사용할 수 있습니다.
  /// Error 타입과 기본 함수는 다음과 같습니다.
  /// - auth : 로그아웃 후 로그인 창으로 이동하는 alertview를 띄운다
  /// - badrequest : error메시지를 프린트
  /// - badrequest : error메시지를 프린트
  /// - notfound : error메시지를 프린트
  /// - server : 서버 에러 발생 알림을 띄운다.
  /// - error(String) : 기타 에러이므로, 에러 디스크립션과 메시지를 프린트
  /// Error 타입에 따른 실행 함수를 지정해줄 수 있는 함수입니다.
  /// parameter는 actions이고, actions의 형태는 APIError 그리고 Action의 튜플 형태의 배열입니다.
  public func map<D> (_ type: D.Type, atKeyPath keyPath: String? = nil , actions : [(APIError, errAction?)]) -> Observable<D> where D : Decodable{
    return self
      .flatMapLatest{ result -> Observable<D> in
        switch result {
        case .success(let res):
          if let mapped = try? res.map(D.self, atKeyPath: keyPath) {
            return Observable<D>.just(mapped)
          }
          else {
            return .empty()
          }
        case .failure(let err):
          for e in actions {
            if err == e.0 {
              (e.1 ?? {print(err.message)})()
            }
          }
          //                    if err == .auth {
          //                        LoginManager.shared.sendLogInPage()
          //                    }
          
          return .empty()
        }
      }
  }
  
}
