//
//  S3Service.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/25.
//

import Foundation
import Moya
import RxSwift
class S3Service {
  private let provider : MoyaProvider<S3Router>
  init(provider: MoyaProvider<S3Router>) {
    self.provider = provider
  }
}
extension S3Service {
  private func getS3URL() -> Observable<String> {
    provider.rx.request(.s3Storage)
      .retryWithAuthIfNeeded()
      .filterError()
      .asObservable()
      .map(String.self, atKeyPath: "presignedUrl")
  }
  private func sendImage(url: String, image : UIImage) -> Observable<String>{
    provider.rx.request(.sendImg(url: url, img: image))
      .successFlag()
      .asObservable()
      .flatMapLatest{result -> Observable<String> in
        if result {
          if let imgUrl = url.split(separator: "?").first?.description {
            return .just(imgUrl)
          }
          else {
            return .empty()
          }
        }
        else {
          return .empty()
        }
      }
  }
  //하나만 보내기
  func sendImage(image: UIImage) -> Observable<String> {
    weak var `self` = self
    return self?.getS3URL().flatMapLatest{ self?.sendImage(url: $0, image: image) ?? .empty()} ?? .empty()
  }
  //여러개 보내기
  func sendImages(image: [UIImage]) -> Observable<[String]>{
    weak var `self` = self
    guard  let self = self else {return .empty()}
    var observables : [Observable<String>] = []
    for i in image {
      let urlObservable = self.getS3URL()
      let imageURL = urlObservable.flatMapLatest{ url in
          self.sendImage(url: url, image: i)
      }
      observables.append(imageURL)
    }
    return Observable.zip(observables)
  }
  
  func fetchKakaoAddress(keyword: String) -> Observable<Response> {
    provider.rx.request(.fetchKakaoAddress(keyword: keyword))
      .asObservable()
  }
}
