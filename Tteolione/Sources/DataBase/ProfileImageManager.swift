//
//  ProfileImageManager.swift
//  Tteolione
//
//  Created by 전준영 on 2/19/25.
//

import UIKit

final class ProfileImageManager {
    
    static let shared = ProfileImageManager()
    private init() {}

    private let cache = NSCache<NSNumber, UIImage>()

    /// ✅ 프로필 이미지 경로 가져오기
    func getProfileImagePath(for opponentId: Int) -> URL? {
        let fileManager = FileManager.default
        guard let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return directory.appendingPathComponent("\(opponentId)_profile.jpg")
    }
    
    /// ✅ 저장된 프로필 이미지 가져오기 (캐시 또는 파일)
    func getProfileImage(for opponentId: Int, urlString: String) async -> String? {
        // ✅ 메모리 캐시에서 가져오기
        if let cachedImage = cache.object(forKey: NSNumber(value: opponentId)) {
            return getProfileImagePath(for: opponentId)?.path
        }
        
        guard let filePath = getProfileImagePath(for: opponentId) else { return nil }
        
        // ✅ 기존 저장된 이미지 확인
        if FileManager.default.fileExists(atPath: filePath.path) {
            return filePath.path
        }
        
        // ✅ URL에서 다운로드 및 저장 (ImageCacheManager 활용)
        return await downloadAndSaveProfileImage(from: urlString, opponentId: opponentId)
    }
    
    /// ✅ URL에서 프로필 이미지 다운로드 후 저장 (변경 감지 포함)
    private func downloadAndSaveProfileImage(from urlString: String, opponentId: Int) async -> String? {
        guard let url = URL(string: urlString) else { return nil }
        guard let filePath = getProfileImagePath(for: opponentId) else { return nil }

        do {
            // ✅ ImageCacheManager를 활용하여 이미지 다운로드 및 캐싱
            guard let newImage = await ImageCacheManager.shared.loadImage(from: url) else {
                return nil
            }
            
            // ✅ 기존 저장된 이미지와 비교 (변경 감지)
            if FileManager.default.fileExists(atPath: filePath.path),
               let existingData = try? Data(contentsOf: filePath),
               let newImageData = newImage.jpegData(compressionQuality: 0.8),
               existingData == newImageData {
                print("✅ [프로필] 변경 사항 없음, 기존 이미지 유지")
                return filePath.path
            }
            
            // ✅ 변경되었거나 새로 다운로드한 경우 기존 이미지 삭제 후 저장
            try? FileManager.default.removeItem(at: filePath) // 기존 파일 삭제
            if let newImageData = newImage.jpegData(compressionQuality: 0.8) {
                try newImageData.write(to: filePath) // 새 이미지 저장
            }
            
            print("✅ [프로필] 변경 감지됨, 새 이미지 저장 완료: \(filePath.path)")

            // ✅ 메모리 캐시에 저장
            cache.setObject(newImage, forKey: NSNumber(value: opponentId))
            
            return filePath.path
        } catch {
            print("❌ [프로필] 다운로드 실패: \(error.localizedDescription)")
            return nil
        }
    }
}
