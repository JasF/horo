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
        virtual unsigned long long int unsignedLongLongIntForColumn(std::string columnName) = 0;
        virtual bool boolForColumn(string columnName)=0;
        virtual double doubleForColumn(std::string columnName)=0;
    };
    
    typedef reff<_ResultSet> ResultSet;
    
    
    template<class T>
    strong<T> resultSetToJsonValue(strong<ResultSet> resultSet) {
        Json::Value resultData;
        strong<T> result = new T();
        Json::Value keys = result->encoded();
        
        for( Json::ValueIterator it = keys.begin(); it != keys.end(); ++it )
        {
            std::string key = it.key().asString();
            Json::Value &value = *it;
            if (value.isDouble()) {
                resultData[key] = resultSet->doubleForColumn(key);
            }
            else if (value.isBool()) {
                resultData[key] = resultSet->boolForColumn(key);
            }
            else if (value.isUInt64()) {
                resultData[key] = resultSet->unsignedLongLongIntForColumn(key);
            }
            else if (value.isInt()) {
                resultData[key] = resultSet->intForColumn(key);
            }
            else if (value.isString()) {
                resultData[key] = resultSet->stringForColumn(key);
            }
            else {
                SCAssert(false, "Unhandled type for key");
            }
        }
        
        result->decode(resultData);
        return result;
    }
};

#endif /* resultset_h */
