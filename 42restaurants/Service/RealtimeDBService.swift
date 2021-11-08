//
//  RealtimeDBService.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/11/08.
//

import Foundation
import Firebase
import CodableFirebase

class RealtimeDBService {
    static let shared = RealtimeDBService()
    
    
    
    func deleteCommentByCommentKey(commentKey: String) {
        let ref: DatabaseReference = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        ref.child("stores").getData(completion: { error, snapshot in
            if snapshot.exists() {
                guard let value = snapshot.value else { return }
                do {
                    let storesData = try FirebaseDecoder().decode([String : StoreInfo].self, from: value)
                    for storeData in storesData {
                        let comments = storeData.value.comments
                        for comment in comments {
                            if comment.key == commentKey {
                                var storeImageUpdates = [String: Any]()
                                
                                if let commentImages = comment.value.images {
                                    let commentImageValues = commentImages.values
                                    
                                    for storeImage in storeData.value.images {
                                        var shouldBeDeleted: Bool = false
                                        for commentImageValue in commentImageValues {
                                            if commentImageValue.imageUrl == storeImage.value.imageUrl {
                                                shouldBeDeleted = true
                                                break;
                                            }
                                        }
                                        if shouldBeDeleted == false {
                                            storeImageUpdates[storeImage.key] = [
                                                "createDate": storeImage.value.createDate,
                                                "modifyDate": storeImage.value.modifyDate,
                                                "imageUrl": storeImage.value.imageUrl
                                            ]
                                        }
                                    }
                                } else {
                                    for storeImage in storeData.value.images {
                                        storeImageUpdates[storeImage.key] = [
                                            "createDate": storeImage.value.createDate,
                                            "modifyDate": storeImage.value.modifyDate,
                                            "imageUrl": storeImage.value.imageUrl
                                        ]
                                    }
                                }
                                
                                let updates = [
                                    "stores/\(storeData.key)/comments/\(commentKey)": nil,
                                    "stores/\(storeData.key)/commentCount": ServerValue.increment(-1),
                                    "stores/\(storeData.key)/images" : storeImageUpdates
                                ] as [String : Any?]
                                
                                ref.updateChildValues(updates as [AnyHashable : Any])

                                guard let autoId = ref.child("reports/deleted").childByAutoId().key
                                else { return }
                                ref.child("reports/deleted/\(autoId)").setValue(comment.value.userId)

                                return
                            }
                        }
                    }
                } catch let e {
                    print(e.localizedDescription)
                }
            }
        })
    }
    
    
}
