//
//  horoscopedao.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef horoscopedao_h
#define horoscopedao_h

#include "base/horobase.h"
#include "data/horoscopedto.h"

namespace horo {
    
    class _HoroscopeDAO {
    public:
        virtual ~_HoroscopeDAO() {}
        virtual bool writeHoroscope(strong<HoroscopeDTO> horoscope) = 0;
        virtual strong<HoroscopeDTO> readHoroscope(uint64_t date, HoroscopeType type) = 0;
        virtual void create()=0;
    };
    
    typedef reff<_HoroscopeDAO> HoroscopeDAO;
    
};

#endif /* horoscopedao_h */
