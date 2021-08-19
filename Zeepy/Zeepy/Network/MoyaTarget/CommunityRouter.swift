//
//  CommunityRouter.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/01.
//

import Foundation
import Moya

enum CommunityRouter {
  case fetchPostList(param: CommunityRequest)
  case addPostList(param: SaveCommunityRequest)
  case fetchPostDetail(id: Int)
  case modifyPostDetail(id: Int)
  case addComment(id: Int , param: PostCommentRequest)
  case fetchPostLike(id: Int)
  case addPostLike(param: LikeRequest)
  case deletePostLike(param: LikeRequest)
  case fetchParticipation(id:Int)
  case addParticipation(id:Int, param : JoinRequset)
  case modifyParticipation(id:Int)
}
extension CommunityRouter : TargetType {
  public var baseURL: URL {
    return URL(string: Environment.baseUrl)!
  }
  var path: String {
    switch self {
    case .fetchPostList(param: _):
      return "/community"
    case .addPostList(param: _):
      return "/community"
    case .fetchPostDetail(id: let id):
      return "/community/\(id)"
    case .modifyPostDetail(id: let id):
      return "/community/\(id)"
    case .addComment(id: let id, param: _):
      return "/community/comment/\(id)"
    case .fetchPostLike(id: let id):
      return "/community/likes/\(id)"
    case .addPostLike(param: _):
      return "/community/like"
    case .deletePostLike(param: _):
      return "/community/like"
    case .fetchParticipation(id: let id):
      return "/community/participation/\(id)"
    case .addParticipation(id: let id, param: _):
      return "/community/participation/\(id)"
    case .modifyParticipation(id: let id):
      return "/community/participation/\(id)"
    }
  }
  var method: Moya.Method {
    switch self {
    case .fetchPostList(param: let param):
      return .get
    case .addPostList(param: let param):
      return .post
    case .fetchPostDetail(id: let id):
      return .get
    case .modifyPostDetail(id: let id):
      return .put
    case .addComment(id: let id, param: let param):
      return .post
    case .fetchPostLike(id: let id):
      return .get
    case .addPostLike(param: let param):
      return .post
    case .deletePostLike(param: let param):
      return .delete
    case .fetchParticipation(id: let id):
      return .get
    case .addParticipation(id: let id, param: let param):
      return .post
    case .modifyParticipation(id: let id):
      return .put
    }
  }
  var sampleData: Data {
    return Data()
  }
  var task: Task {
    switch self {
    case .fetchPostList(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: URLEncoding
                                  .default)
    case .addPostList(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding
                                  .default)
    case .fetchPostDetail(id: let id):
      return .requestPlain
    case .modifyPostDetail(id: let id):
      return .requestPlain
    case .addComment(id: let id, param: let param):
      return .requestParameters(parameters: try! param.writeCommentRequestDto.asParameter(), encoding: JSONEncoding
                                  .default)
    case .fetchPostLike(id: let id):
      return .requestPlain
    case .addPostLike(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: URLEncoding.queryString)

    case .deletePostLike(param: let param):

      return .requestParameters(parameters: try! param.asParameter(), encoding: URLEncoding.default)

    case .fetchParticipation(id: let id):
      return .requestPlain
    case .addParticipation(id: let id, param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding
                                  .default)
    case .modifyParticipation(id: let id):
      
      return .requestPlain
    }
  }
  var headers: [String : String]? {
    switch self {
    default:
      return ["Content-Type":"application/json",
              "X-AUTH-TOKEN" : UserDefaultHandler.accessToken!]
    }
  }
}
