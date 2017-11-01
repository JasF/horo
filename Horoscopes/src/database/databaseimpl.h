//
//  databaseimpl.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef databaseimpl_h
#define databaseimpl_h

#include "database.h"

namespace horo {
    
    class DatabaseImplPrivate {
    public:
        virtual ~DatabaseImplPrivate() {}
        virtual Database *createDatabase(std::string path) = 0;
    };

    class DatabaseImpl : public Database {
    public:
        static void setPrivateInstance(DatabaseImplPrivate *privateInstance);
    public:
        DatabaseImpl(std::string path);
        ~DatabaseImpl() override {}
    public:
        bool executeUpdate(std::string query, Json::Value parameters) override;
        strong<ResultSet> executeQuery(std::string query, Json::Value parameters = Json::Value()) override;
        int64_t lastInsertRowId() const override;
        std::string lastErrorMessage() override;
        
    private:
        strong<Database> p_;
    };
    
};

#endif /* databaseimpl_h */
