//
//  horoscopedaoimpl.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef horoscopedaoimpl_h
#define horoscopedaoimpl_h

#include "horoscopedao.h"
#include "database/database.h"

namespace horo {
    class HoroscopeDAOImpl : public HoroscopeDAO {
    public:
        HoroscopeDAOImpl(strong<Database> database) : database_(database) {
            SCParameterAssert(database_);
        }
        ~HoroscopeDAOImpl() override {}
    public:
        bool writeHoroscope(strong<HoroscopeDTO> horoscope) override;
        strong<HoroscopeDTO> readHoroscope(uint64_t date, HoroscopeType type) override;
        void create() override;
    private:
        strong<Database> database_;
    };
};

#endif /* horoscopedaoimpl_h */
