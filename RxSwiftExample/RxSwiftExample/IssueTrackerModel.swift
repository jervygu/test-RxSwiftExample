//
//  IssueTrackerModel.swift
//  RxSwiftExample
//
//  Created by Jervy Umandap on 8/17/24.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTrackerModel {
    let provider: MoyaProvider<GitHub>!
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<Repository?> in
                print("Name: \(name)")
                return self
                    .findRepository(name: name)
            }
            .flatMapLatest { repository -> Observable<[Issue]?> in
                guard let repository = repository else { return Observable.just(nil) }
                print("Repository: \(repository.fullName)")
                return self.findIssues(repository: repository)
            }
            .replaceNilWith([])
    }
    
    internal func findIssues(repository: Repository) -> Observable<[Issue]?> {
        return self.provider.rx
            .request(GitHub.issues(repositoryFullName: repository.fullName))
            .debug()
            .asObservable()
            .mapOptional(to: [Issue].self)
    }
    
    internal func findRepository(name: String) -> Observable<Repository?> {
        return self.provider.rx
            .request(GitHub.repo(fullName: name))
            .debug()
            .asObservable()
            .mapOptional(to: Repository.self)
        
    }
}
