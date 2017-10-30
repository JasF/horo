//
//  firestorefactoryimpl.c
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "firestorefactoryimpl.h"
#include "firestoreimpl.h"

namespace horo {
  
    strong<CollectionReference> FirestoreFactoryImpl::createCollectionReference(strong<CollectionReference> otherReference) {
        return nullptr;
    }
    
    strong<DocumentReference> FirestoreFactoryImpl::createDocumentReference(strong<DocumentReference> otherReference) {
        return nullptr;
    }
    
    strong<Firestore> FirestoreFactoryImpl::createFirestore() {
        return new FirestoreImpl(this);
    }
    
    strong<DocumentSnapshot> FirestoreFactoryImpl::createDocumentSnapshot(strong<DocumentSnapshot> otherReference) {
        return nullptr;
    }
    
};
