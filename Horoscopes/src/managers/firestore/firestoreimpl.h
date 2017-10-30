//
//  firestoreimpl.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef firestoreimpl_h
#define firestoreimpl_h

#include "firestore.h"
#include "firestorefactory.h"

namespace horo {
    
    class FirestoreImpl : public Firestore {
    public:
        static void setPrivateInstance(Firestore *privateInstance);
    public:
        FirestoreImpl(strong<FirestoreFactory> factory) : factory_(factory) {}
        ~FirestoreImpl() override {}
        strong<CollectionReference> collectionWithPath(std::string path) override;
    
    private:
        strong<FirestoreFactory> factory_;
    };
    
    
};

#endif /* firestoreimpl_h */
