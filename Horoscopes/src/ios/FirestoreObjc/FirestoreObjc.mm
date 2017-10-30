//
//  FirestoreObjc.m
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FirestoreObjc.h"
#include "managers/firestore/firestoreimpl.h"
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseFirestore/FirebaseFirestore.h>

namespace horo {
    class DocumentReferenceObjc : public DocumentReference {
    public:
        DocumentReferenceObjc() {}
        ~DocumentReferenceObjc() override {}
    };
    
    class CollectionReferenceObjc : public CollectionReference {
    public:
        CollectionReferenceObjc(FIRCollectionReference *reference) : reference_(reference) {}
        ~CollectionReferenceObjc() override {}
        
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
+ (void)load {
    horo::FirestoreImpl::setPrivateInstance(horo::FirestoreObjc::shared());
}
@end
