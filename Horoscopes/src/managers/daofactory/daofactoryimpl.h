//
//  DAOFactoryImplimpl.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef DAOFactoryImplimpl_h
#define DAOFactoryImplimpl_h

#include "managers/horoscopedao/horoscopedao.h"
#include "managers/daofactory/daofactory.h"
#include "database/database.h"

namespace horo {
    class DAOFactoryImpl : public DAOFactory {
    public:
        DAOFactoryImpl(strong<Database> database) : database_(database) {}
        ~DAOFactoryImpl() override {}
        strong<HoroscopeDAO> createHoroscopeDAO() override;
    private:
        strong<Database> database_;
    };
};

#endif /* DAOFactoryImplimpl_h */
