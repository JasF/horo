//
//  firestorefactoryimpl.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef firestorefactoryimpl_h
#define firestorefactoryimpl_h

#include "firestorefactory.h"

namespace horo {
    
    class FirestoreFactoryImpl : public FirestoreFactory {
    public:
        FirestoreFactoryImpl() {}
        ~FirestoreFactoryImpl() override {}
        strong<CollectionReference> createCollectionReference(strong<CollectionReference> otherReference) override;
        strong<DocumentReference> createDocumentReference(strong<DocumentReference> otherReference) override;
        strong<Firestore> createFirestore() override;
        strong<DocumentSnapshot> createDocumentSnapshot(strong<DocumentSnapshot> otherReference) override;
    };
    
    typedef reff<_Firestore> Firestore;
    
};


#endif /* firestorefactoryimpl_h */
