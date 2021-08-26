//
//  AddPostViewModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/12.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Moya
import YPImagePicker
class AddPostViewModel:Services, ViewModelType {
  
  private let disposeBag = DisposeBag()
  private let service = CommunityService(provider: MoyaProvider<CommunityRouter>(plugins:[NetworkLoggerPlugin()]))
  struct TypeInput {
    let postType : Observable<PostType>
    let nextBtnTap : Observable<Void>
  }
  struct TypeOutput {
    let isSelected: Observable<Bool>
    let currentSelection : Observable<PostType>
    let selectedType: Observable<AddPostViewContoller?>
  }
  
  struct ContentInput {
    let titleText : Observable<String?>
    
    let contentText : Observable<String?>
    
    let productTitle : Observable<String?>
    let productPrice : Observable<Int?>
    let productMall : Observable<String?>
    let tradeType : Observable<String?>
    
    let targetMember: Observable<Int?>

    let memberInfo: Observable<CheckBoxContent>
  }
  struct ContentOutput {
    let isEnabled: Observable<Bool>
    let checkedContent: Observable<CheckBoxContent>
  }
  
  struct Input {
    let loadTrigger: Observable<Void>
    let currentImages: Observable<[YPMediaPhoto]>
    let deleteImage : Observable<YPMediaPhoto>
    let post: Observable<Void>
  }
  struct Output {
    let currentImage : Observable<[YPMediaPhoto]>
    let postResult: Observable<Bool>
  }
  
  struct State {
    var selectedType: PostType?
    var titleText : String?
    var contentText: String?
    
    var productTitle : String?
    var productPrice :Int?
    var productMall :String?
    var tradeType : String?
    
    var targetMember: Int?
    
    var imgs : [YPMediaPhoto]?

    var memberInfo: CheckBoxContent?
  }
  var state = State()
}
extension AddPostViewModel {
  func selectType(type : TypeInput) -> TypeOutput {
    weak var `self` = self
    let isSelected = type.postType.map{ selection -> Bool in
      self?.state.selectedType = selection
      return true
    }
    let vc = type.nextBtnTap.withLatestFrom(type.postType).flatMapLatest{ type -> Observable<AddPostViewContoller?> in
      if let vm = self {
        return Observable.just(AddPostViewContoller(nibName: nil, bundle: nil, postType: type, viewModel: vm))
      }
      else {
        return .empty()
      }
    }
    return .init(isSelected: isSelected,
                 currentSelection: type.postType,
                 selectedType: vc)
  }
  func MutateContent(input: ContentInput) -> ContentOutput {
    weak var `self` = self
    if state.selectedType == .deal {
      
    
    let enabled = Observable.combineLatest(input.memberInfo,
                                           input.productMall,
                                           input.productPrice,
                                           input.productTitle,
                                           input.targetMember,
                                           input.titleText,
                                           input.contentText,
                                           input.tradeType).map{ member, mall, price, product, count, title, content, type  -> Bool in
                                            self?.state.memberInfo = member
                                            self?.state.productMall = mall
                                            self?.state.productPrice = price
                                            self?.state.productTitle = product
                                            self?.state.targetMember = count
                                            self?.state.titleText = title
                                            self?.state.contentText = content
                                            self?.state.tradeType = type
                                          
                                            if mall?.isEmpty == false && price.isNotNil && product?.isEmpty == false && count.isNotNil && title?.isEmpty == false && content?.isEmpty == false && type?.isEmpty == false {
                                              return true
                                            }
                                            else {
                                              return false
                                            }
                                           }
    return .init(isEnabled: enabled, checkedContent: input.memberInfo)
    }
    else {
      let enabled = Observable.combineLatest(input.titleText,
                                             input.contentText
                                             ).map{  title, content -> Bool in
                                           
                                              self?.state.titleText = title
                                              self?.state.contentText = content
                                            
                                              if title?.isEmpty == false && content?.isEmpty == false {
                                                return true
                                              }
                                              else {
                                                return false
                                              }
                                             }
      return .init(isEnabled: enabled, checkedContent: input.memberInfo)
    }
  }
  func transform(input: Input) -> Output {
    weak var `self` = self

    let items = input.loadTrigger
      .flatMapLatest{ _ -> Observable<[YPMediaPhoto]> in
        return self?.configureImages(deleteAction: input.deleteImage,
                                     resetAction: input.currentImages,
                                     origin: self?.state.imgs ?? []) ?? .empty()
      }.share()
    let result = input.post.flatMapLatest{ _ in
      self?.param() ?? .empty()
    }.flatMapLatest{ param in
      self?.service.addPostList(param: param) ?? .empty()
    }
    return .init(currentImage: items,
                 postResult: result)
  }
  func configureImages(
    deleteAction: Observable<YPMediaPhoto>,
    resetAction: Observable<[YPMediaPhoto]>,
    origin:[YPMediaPhoto]) -> Observable<[YPMediaPhoto]> {
    enum Action {
      case delete(model : YPMediaPhoto)
      case reset(modle: [YPMediaPhoto])
    }
    return Observable.merge(deleteAction.map(Action.delete),
                            resetAction.map(Action.reset))
      .scan(into: origin) {state, action in
        switch action {
        case let .delete(model) :
          state.removeAll(where: {$0.asset == model.asset})
        case .reset(modle: let modle):
          state = modle
        }
        self.state.imgs = state
      }.startWith(origin)
  }
  func param() -> Observable<SaveCommunityRequest> {
    weak var `self` = self
    guard let self = self else {return .empty()}
    let state = state
    let address : String? = UserManager.shared.currentAddress?.cityDistinct
    guard let images = state.imgs else {
      return .just(SaveCommunityRequest(address: address ?? "",
                                        communityCategory: state.selectedType?.requestEnum ?? "",
                                        content: state.contentText ?? "",
                                        title: state.titleText ?? "",
                                        imageUrls: nil,
                                        instructions: state.tradeType,
                                        productName: state.productTitle ,
                                        productPrice: state.productPrice ,
                                        purchasePlace: state.productMall ,
                                        sharingMethod: state.memberInfo?.rawValue ,
                                        targetNumberOfPeople: state.targetMember
                                       ))
    }
    let imageURL = self.s3Service.sendImages(image: images.map{$0.image})
    return imageURL.map{ img -> SaveCommunityRequest in
      SaveCommunityRequest(address: address ?? "",
                   communityCategory: state.selectedType?.requestEnum ?? "",
                   content: state.contentText ?? "",
                   title: state.titleText ?? "",
                   imageUrls: img,
                   instructions: state.tradeType,
                   productName: state.productTitle ,
                   productPrice: state.productPrice ,
                   purchasePlace: state.productMall ,
                   sharingMethod: state.memberInfo?.rawValue ,
                   targetNumberOfPeople: state.targetMember
                  )
    }
  }
}
