//
//  FirestoreObjc.m
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FirestoreObjc.h"
#include "managers/firestore/firestoreimpl.h"
#include "managers/firestore/documentsnapshot.h"
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseFirestore/FirebaseFirestore.h>
#include "json/reader.h"

namespace horo {
    class DocumentSnapshotObjc : public DocumentSnapshot {
    public:
        DocumentSnapshotObjc(FIRDocumentSnapshot *snapshot)
        : snapshot_(snapshot) {}
        ~DocumentSnapshotObjc() override {}
    public:
        Json::Value data() const override {
            if (!snapshot_.exists) {
                Json::Value empty;
                return empty;
            }
            NSData *data = [NSJSONSerialization dataWithJSONObject:snapshot_.data options:0 error:nil];
            std::string jsonString((const char *)data.bytes, data.length);
            Json::Reader reader;
            Json::Value root;
            if (!reader.parse(jsonString, root)) {
                Json::Value empty;
                return empty;
            }
            return root;
        }
    private:
        FIRDocumentSnapshot *snapshot_;
    };
    
    class DocumentReferenceObjc : public DocumentReference {
    public:
        DocumentReferenceObjc(FIRDocumentReference *reference)
        : reference_(reference) {}
        ~DocumentReferenceObjc() override {}
    public:
        virtual void getDocumentWithCompletion(std::function<void(strong<DocumentSnapshot> snapshot, error err)> completion) override {
            [reference_ getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable aError) {
                if (snapshot) {
                    strong<DocumentSnapshot> cSnapshot = new DocumentSnapshotObjc(snapshot);
                    if (completion) {
                        completion(cSnapshot, horo::error());
                    }
                    return;
                }
                horo::error err(aError.localizedDescription.UTF8String, (int)aError.code);
                if (completion) {
                    completion(nullptr, err);
                }
            }];
        }
        
    private:
        FIRDocumentReference *reference_;
    };
    
    class CollectionReferenceObjc : public CollectionReference {
    public:
        CollectionReferenceObjc(FIRCollectionReference *reference)
        : reference_(reference) {}
        ~CollectionReferenceObjc() override {}
        strong<DocumentReference> documentWithPath(std::string path) override {
            NSString *sPath = [[NSString alloc] initWithUTF8String:path.c_str()];
            FIRDocumentReference *reference = [reference_ documentWithPath:sPath];
            if (!reference) {
                return nullptr;
            }
            strong<DocumentReference> document = new DocumentReferenceObjc(reference);
            return document;
        }
        
    private:
        FIRCollectionReference *reference_;
    };
    
    class FirestoreObjc : public Firestore {
    public:
        static FirestoreObjc *shared() {
            static FirestoreObjc *staticInstance = nullptr;
            if (!staticInstance) {
                staticInstance = new FirestoreObjc();
            }
            return staticInstance;
        }
    public:
        FirestoreObjc() : db_(nullptr) {
        }
        ~FirestoreObjc() override {}
        strong<CollectionReference> collectionWithPath(std::string path) override {
            if (!db_) {
                db_ = [FIRFirestore firestoreForApp:[FIRApp defaultApp]];
            }
            NSString *string = [[NSString alloc] initWithUTF8String:path.c_str()];
            FIRCollectionReference *reference = [db_ collectionWithPath:string];
            strong<CollectionReference> collection = new CollectionReferenceObjc(reference);
            return collection;
        }
        
    private:
        FIRFirestore *db_;
    };
    
};

/*
 _db = ;
@property (strong, nonatomic) FIRFirestore *db;
@property (strong, nonatomic) FIRCollectionReference *collRef;
@property (strong, nonatomic) FIRDocumentReference *docRef;
*/
@implementation FirestoreObjc
+ (void)doLoading {
    horo::FirestoreImpl::setPrivateInstance(horo::FirestoreObjc::shared());
}
@end
