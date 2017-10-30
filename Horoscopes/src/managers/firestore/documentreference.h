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
#include "documentsnapshot.h"

namespace horo {
    
    class _DocumentReference {
    public:
        virtual ~_DocumentReference() {}
    public:
        virtual void getDocumentWithCompletion(std::function<void(strong<DocumentSnapshot> snapshot, error err)> completion) = 0;
    };
    
    typedef reff<_DocumentReference> DocumentReference;
    
};

#endif /* documentreference_h */
