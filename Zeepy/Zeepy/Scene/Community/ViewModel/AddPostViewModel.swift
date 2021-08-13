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
class AddPostViewModel  {
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
  
  struct AddPostInput {
    let post: Observable<Void>
  }
  struct AddPostOutput {
    let postResult: Observable<Bool>
  }
  
  struct State {
    var selectedType: PostType?
    var titleText : String?
    
    var productTitle : String?
    var productPrice :Int?
    var productMall :String?
    var tradeType : String?
    
    var targetMember: Int?

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
    let enabled = Observable.combineLatest(input.memberInfo,
                                           input.productMall,
                                           input.productPrice,
                                           input.productTitle,
                                           input.targetMember,
                                           input.titleText,
                                           input.tradeType).map{ member, mall, price, product, count, title, type  -> Bool in
                                            self?.state.memberInfo = member
                                            self?.state.productMall = mall
                                            self?.state.productPrice = price
                                            self?.state.productTitle = product
                                            self?.state.targetMember = count
                                            self?.state.titleText = title
                                            self?.state.tradeType = type
                                            if mall?.isEmpty == false && price.isNotNil && product?.isEmpty == false && count.isNotNil && title?.isEmpty == false && type?.isEmpty == false {
                                              return true
                                            }
                                            else {
                                              return false
                                            }
                                           }
    return .init(isEnabled: enabled, checkedContent: input.memberInfo)
  }
  func addPost(inputs: AddPostInput) -> AddPostOutput {
    weak var `self` = self
    let result = inputs.post.flatMapLatest{ _ in
      self?.service.addPostList(param: self!.param()) ?? .empty()
    }
    return .init(postResult: result)
  }
  func param() -> SaveCommunityRequest {
    let state = state
    return .init(address: "",
                 communityCategory: "",
                 content: "",
                 currentNumberOfPeople: 0,
                 imageUrls: [],
                 instructions: "",
                 productName: "",
                 productPrice: 0,
                 purchasePlace: "",
                 sharingMethod: "",
                 targetNumberOfPeople: 0,
                 title: "",
                 writerId: 0)
  }
}
