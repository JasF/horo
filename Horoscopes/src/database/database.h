//
//  database.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef database_h
#define database_h

#include "base/horobase.h"

namespace horo {
    class _Database {
    public:
        virtual ~_Database() {}
        virtual bool executeUpdate(std::string query, Json::Value parameters = Json::Value()) = 0;
    };
    
    typedef reff<_Database> Database;
};



#endif /* database_h */
