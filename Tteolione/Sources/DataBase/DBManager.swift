//
//  DBManager.swift
//  Tteolione
//
//  Created by 전준영 on 2/12/25.
//

import Foundation
import SwiftData
import RxSwift

final class DBManager {
    
    var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    static func makeModelContainer() -> ModelContainer {
        let schema = Schema([ChatMessageData.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("ModelContainer 생성 실패: \(error)")
        }
    }
}

//MARK: - RxSwift 기반 CRUD Method
extension DBManager {
    
    func addItem(_ message: ChatMessageData) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self, let modelContext else {
                completable(.error(NSError(domain: "DB Error", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            
            modelContext.insert(message)
            do {
                try modelContext.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func fetchItems(chatRoomID: String) -> Single<[ChatMessageData]> {
        return Single.create { [weak self] single in
            guard let self, let modelContext else {
                single(.failure(NSError(domain: "DB Error", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            
            let request = FetchDescriptor<ChatMessageData>(
                predicate: #Predicate { $0.chatRoomID == chatRoomID },
                sortBy: [SortDescriptor(\.timestamp)]
            )
            
            do {
                let messages = try modelContext.fetch(request)
                single(.success(messages))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func updateItem(_ message: ChatMessageData) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self, let modelContext else {
                completable(.error(NSError(domain: "DB Error", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            
            do {
                try modelContext.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func removeItem(_ message: ChatMessageData) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self, let modelContext else {
                completable(.error(NSError(domain: "DB Error", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            
            modelContext.delete(message)
            do {
                try modelContext.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func deleteAllItems(in chatRoomID: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self, let modelContext else {
                completable(.error(NSError(domain: "DB Error", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            
            let request = FetchDescriptor<ChatMessageData>(predicate: #Predicate { $0.chatRoomID == chatRoomID })
            
            do {
                let messages = try modelContext.fetch(request)
                messages.forEach { modelContext.delete($0) }
                try modelContext.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
