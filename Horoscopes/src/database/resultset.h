//
//  resultset.h
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef resultset_h
#define resultset_h


#include "base/horobase.h"

namespace horo {
    class _ResultSet {
    public:
        virtual ~_ResultSet() {}
        virtual bool next() = 0;
        virtual int intForColumn(std::string columnName) = 0;
        virtual string stringForColumn(std::string columnName) = 0;
    };
    
    typedef reff<_ResultSet> ResultSet;
};

#endif /* resultset_h */
