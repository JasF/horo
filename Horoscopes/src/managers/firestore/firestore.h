//
//  firestore.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef firestore_h
#define firestore_h

#include "base/horobase.h"
#include "collectionreference.h"

namespace horo {
  
    class _Firestore {
    public:
        virtual ~_Firestore() {}
        virtual strong<CollectionReference> collectionWithPath(std::string path) = 0;
    };
    
    typedef reff<_Firestore> Firestore;
    
};

#endif /* firestore_h */
