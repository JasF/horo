//
//  firestoreimpl.c
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "firestoreimpl.h"

namespace horo {
    
static Firestore *g_privateInstance = nullptr;
void FirestoreImpl::setPrivateInstance(Firestore *privateInstance) {
    g_privateInstance = privateInstance;
}
    
strong<CollectionReference> FirestoreImpl::collectionWithPath(std::string path) {
    if (g_privateInstance) {
        return g_privateInstance->collectionWithPath(path);
    }
    return nullptr;
}

};
