//
//  firestorefactory.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef firestorefactory_h
#define firestorefactory_h

#include "base/horobase.h"
#include "firestore.h"
#include "collectionreference.h"
#include "documentreference.h"
#include "documentsnapshot.h"

namespace horo {
    
    class _FirestoreFactory {
    public:
        virtual ~_FirestoreFactory() {}
        virtual strong<CollectionReference> createCollectionReference(strong<CollectionReference> otherReference) = 0;
        virtual strong<DocumentReference> createDocumentReference(strong<DocumentReference> otherReference) = 0;
        virtual strong<Firestore> createFirestore() = 0;
        virtual strong<DocumentSnapshot> createDocumentSnapshot(strong<DocumentSnapshot> otherReference) = 0;
    };
    
    typedef reff<_FirestoreFactory> FirestoreFactory;
    
};

#endif /* firestorefactory_h */
