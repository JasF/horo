//
//  collectionreferenceimpl.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef collectionreferenceimpl_h
#define collectionreferenceimpl_h

#include "collectionreference.h"
#include "firestorefactory.h"

namespace horo {
    
    class CollectionReferenceImpl : public CollectionReference {
    public:
        CollectionReferenceImpl(strong<FirestoreFactory> factory) : factory_(factory) {}
        ~CollectionReferenceImpl() override {}
        
    private:
        strong<FirestoreFactory> factory_;
    };
    
};

#endif /* collectionreferenceimpl_h */
