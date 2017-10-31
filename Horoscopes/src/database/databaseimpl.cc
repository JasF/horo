//
//  databaseimpl.c
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "databaseimpl.h"

namespace horo {
  
    static DatabaseImplPrivate *g_privateInstance = nullptr;
    void DatabaseImpl::setPrivateInstance(DatabaseImplPrivate *privateInstance) {
        g_privateInstance = privateInstance;
    }
    
    DatabaseImpl::DatabaseImpl(std::string path) {
        if (g_privateInstance) {
            p_ = g_privateInstance->createDatabase(path);
        }
    }
    
    bool DatabaseImpl::executeUpdate(std::string query, Json::Value parameters) {
        if (p_) {
            return p_->executeUpdate(query, parameters);
        }
        return false;
    }
    
};
