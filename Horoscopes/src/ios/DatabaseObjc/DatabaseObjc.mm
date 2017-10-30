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

namespace horo {
  
    class DatabaseObjc : public Database
    , public DatabaseImplPrivate {
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
        
        void execute(std::string query, Json::Value parameters) override {
            
        }
        
        
        Database *createDatabase(std::string path) {
            return nullptr;
        }
    };
};

@implementation DatabaseObjc
+ (void)load {
    horo::DatabaseImpl::setPrivateInstance(horo::DatabaseObjc::shared());
}
@end
