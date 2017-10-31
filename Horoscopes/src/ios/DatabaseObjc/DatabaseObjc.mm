//
//  DatabaseObjc.m
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "DatabaseObjc.h"
#include "database/databaseimpl.h"
#import <FMDB/FMDatabase.h>
#include "../../../Categories/NSDictionary+Horo.h"

namespace horo {
  
    class DatabaseObjcImpl :  public Database {
    public:
        DatabaseObjcImpl(std::string path) :db_([FMDatabase databaseWithPath:[[NSString alloc] initWithUTF8String:path.c_str()]]) {
            SCParameterAssert(db_);
        }
        ~DatabaseObjcImpl() override {}
    public:
        bool executeUpdate(std::string query, Json::Value parameters) override {
            NSString *queryString = [[NSString alloc] initWithUTF8String:query.c_str()];
            NSDictionary *dictionary = [NSDictionary horo_dictionaryFromJsonValue:parameters];
            bool result = [db_ executeUpdate:queryString withParameterDictionary:dictionary];
            return result;
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
+ (void)load {
    horo::DatabaseImpl::setPrivateInstance(horo::DatabaseObjc::shared());
}
@end
