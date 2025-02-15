//
//  DBManager.swift
//  Tteolione
//
//  Created by 전준영 on 2/12/25.
//

import Foundation
import SwiftData

final class DBManager {
    
    static let shared = DBManager()
    
    var container: ModelContainer
    var modelContext: ModelContext

    private init() {
        do {
            let schema = Schema([ChatMessageData.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = ModelContext(container)
            print("✅ [DB] modelContext 초기화 완료: \(modelContext)")
        } catch {
            fatalError("❌ ModelContainer 생성 실패: \(error)")
        }
    }
}

// MARK: - CRUD 메서드 (Create, Read, Delete)
extension DBManager {
    
    func addItem<T: PersistentModel>(_ model: T) {
        modelContext.insert(model)
        
        do {
            try modelContext.save()
            print("✅ [DB] 데이터 저장 성공: \(model)")
        } catch {
            print("❌ [DB] 데이터 저장 실패: \(error.localizedDescription)")
        }
    }
    
    func fetchMessages(chatRoomID: Int) -> [ChatMessageData] {
        let request = FetchDescriptor<ChatMessageData>(
            predicate: #Predicate { $0.chatRoomNo == chatRoomID },
            sortBy: [SortDescriptor(\.sendTime, order: .forward)]
        )
        
        do {
            let items: [ChatMessageData] = try modelContext.fetch(request)
            print("✅ [DB] 채팅방(\(chatRoomID)) 메시지 불러오기 성공! 개수: \(items.count)")
            return items
        } catch {
            print("❌ [DB] 채팅방 메시지 불러오기 실패: \(error.localizedDescription)")
            return []
        }
    }
    
    func getLastMessageTime(chatRoomID: Int) -> Int? {
        let messages = fetchMessages(chatRoomID: chatRoomID)
        return messages.last?.sendTime
    }
    
    func removeItem<T: PersistentModel>(_ model: T) {
        modelContext.delete(model)
        
        do {
            try modelContext.save()
            print("✅ [DB] 데이터 삭제 성공: \(model)")
        } catch {
            print("❌ [DB] 데이터 삭제 실패: \(error.localizedDescription)")
        }
    }
}
