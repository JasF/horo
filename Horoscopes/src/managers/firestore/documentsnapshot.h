//
//  documentsnapshot.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef documentsnapshot_h
#define documentsnapshot_h

#include "base/horobase.h"

namespace horo {
    
    class _DocumentSnapshot {
    public:
        virtual ~_DocumentSnapshot() {}
    };
    
    typedef reff<_DocumentSnapshot> DocumentSnapshot;
    
};

#endif /* documentsnapshot_h */
