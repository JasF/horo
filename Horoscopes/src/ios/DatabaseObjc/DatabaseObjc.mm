//
//  DatabaseObjc.m
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "DatabaseObjc.h"
#include "database/databaseimpl.h"
#include "database/resultset.h"
#import <FMDB/FMDatabase.h>
#include "../../../Categories/NSDictionary+Horo.h"

namespace horo {
    
    class ResultSetObjc : public ResultSet {
    public:
        ResultSetObjc(FMResultSet *result) : results_(result) {}
        ~ResultSetObjc() override {}
    public:
        BOOL next() override {
            return [results_ next];
        }
        int intForColumn(std::string columnName) override {
            return [results_ intForColumn:[[NSString alloc] initWithUTF8String:columnName.c_str()]];
        }
        unsigned long long int unsignedLongLongIntForColumn(std::string columnName) override {
            return [results_ unsignedLongLongIntForColumn:[[NSString alloc] initWithUTF8String:columnName.c_str()]];
        }
        std::string stringForColumn(std::string columnName) override {
            NSString *string = [results_ stringForColumn:[[NSString alloc] initWithUTF8String:columnName.c_str()]];
            return [string UTF8String];
        }
    private:
        FMResultSet *results_;
    };
  
    class DatabaseObjcImpl :  public Database {
    public:
        DatabaseObjcImpl(std::string path) :db_([FMDatabase databaseWithPath:[[NSString alloc] initWithUTF8String:path.c_str()]]) {
            SCParameterAssert(db_);
            [db_ open];
        }
        ~DatabaseObjcImpl() override {}
    public:
        bool executeUpdate(std::string query, Json::Value parameters) override {
            NSString *queryString = [[NSString alloc] initWithUTF8String:query.c_str()];
            NSDictionary *dictionary = [NSDictionary horo_dictionaryFromJsonValue:parameters];
            bool result = [db_ executeUpdate:queryString withParameterDictionary:dictionary];
            return result;
        }
        
        strong<ResultSet> executeQuery(std::string query, Json::Value parameters) override {
            NSString *queryString = [[NSString alloc] initWithUTF8String:query.c_str()];
            NSDictionary *dictionary = [NSDictionary horo_dictionaryFromJsonValue:parameters];
            FMResultSet *resultSet = [db_ executeQuery:queryString withParameterDictionary:dictionary];
            ResultSetObjc *cppInstance = new ResultSetObjc(resultSet);
            strong<ResultSet>  op = cppInstance;
            return op;
        }
        
        int64_t lastInsertRowId() const override {
            return [db_ lastInsertRowId];
        }
        
        virtual std::string lastErrorMessage() override {
            return [[db_ lastErrorMessage] UTF8String];
        }
        
    private:
        FMDatabase *db_;
    };
    
    class DatabaseObjc : public DatabaseImplPrivate {
    public:
        DatabaseObjc(){}
        ~DatabaseObjc() override {}
        static DatabaseObjc *shared() {
            static DatabaseObjc *staticInstance = nullptr;
            if (!staticInstance) {
                staticInstance = new DatabaseObjc();
            }
            return staticInstance;
        }
        
        
        Database *createDatabase(std::string path) override {
            return new DatabaseObjcImpl(path);
        }
    };
};

@implementation DatabaseObjc
+ (void)doLoading {
    horo::DatabaseImpl::setPrivateInstance(horo::DatabaseObjc::shared());
}
@end
