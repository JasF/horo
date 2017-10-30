//
//  documentreference.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef documentreference_h
#define documentreference_h

#include "base/horobase.h"

namespace horo {
    
    class _DocumentReference {
    public:
        virtual ~_DocumentReference() {}
    };
    
    typedef reff<_DocumentReference> DocumentReference;
    
};

#endif /* documentreference_h */
