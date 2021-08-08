//
//  LoginModel.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/08/08.
//

import Foundation
import RxSwift
import RxCocoa

struct LoginModel {
    let id : PublishSubject<String>
    let password : PublishSubject<String>
    let findID : PublishSubject<Bool>
    let findPW : PublishSubject<Bool>
    let signUp : PublishSubject<Bool>
    let login : PublishSubject<Bool>
}
