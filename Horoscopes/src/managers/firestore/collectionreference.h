//
//  collectionreference.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef collectionreference_h
#define collectionreference_h

#include "base/horobase.h"
#include "documentreference.h"

namespace horo {
    
    class _CollectionReference {
    public:
        virtual ~_CollectionReference() {}
    };
    
    typedef reff<_CollectionReference> CollectionReference;
    
};

#endif /* collectionreference_h */
