//
//  horoscopesservice.h
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef horoscopesservice_h
#define horoscopesservice_h

#include "base/horobase.h"
#include "data/horoscopedto.h"

namespace horo {
    
    typedef std::function<void(HoroscopeDTO *yesterday,
                               HoroscopeDTO *today,
                               HoroscopeDTO *tomorrow,
                               HoroscopeDTO *week,
                               HoroscopeDTO *month,
                               HoroscopeDTO *year)> HoroscopesServiceCallback;
    class _HoroscopesService {
    public:
        virtual ~_HoroscopesService() {}
        virtual void fetchHoroscopes(HoroscopesServiceCallback callback) = 0;
    };
    
    typedef reff<_HoroscopesService> HoroscopesService;
};

#endif /* horoscopesservice_h */
