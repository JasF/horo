//
//  documentsnapshotimpl.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef documentsnapshotimpl_h
#define documentsnapshotimpl_h

#include "documentsnapshot.h"
#include "firestorefactory.h"

namespace horo {
    
    class DocumentSnapshotImpl : public DocumentSnapshot {
    public:
        DocumentSnapshotImpl(strong<FirestoreFactory> factory) : factory_(factory) {}
        ~DocumentSnapshotImpl() override {}
        
    private:
        strong<FirestoreFactory> factory_;
    };
    
    
};

#endif /* documentsnapshotimpl_h */
