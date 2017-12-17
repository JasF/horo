//
//  horoscopesserviceimpl.h
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef horoscopesserviceimpl_h
#define horoscopesserviceimpl_h

#include "managers/horoscopesservice/horoscopesservice.h"
#include "managers/firestore/firestore.h"
#include "managers/horoscopesparser/horoscopesparser.h"
#include "managers/horoscopedao/horoscopedao.h"

namespace horo {
    
    class HoroscopesServiceImpl : public HoroscopesService {
    public:
        HoroscopesServiceImpl(strong<Firestore> firestore,
                              strong<HoroscopesParser> parser,
                              strong<HoroscopeDAO> horoscopeDAO)
        : firestore_(firestore),
        parser_(parser),
        horoscopeDAO_(horoscopeDAO) {
            SCParameterAssert(firestore_.get());
            SCParameterAssert(parser_.get());
            SCParameterAssert(horoscopeDAO_.get());
            
            horoscopeDAO_->create();
        }
        ~HoroscopesServiceImpl() override {}
        
    public:
        void fetchHoroscopes(strong<Zodiac> zodiac, HoroscopesServiceCallback callback) override;
        
    private:
        void offlineFetchHoroscopes(strong<Zodiac> zodiac, HoroscopesServiceCallback callback);
        
    private:
        strong<Firestore> firestore_;
        strong<HoroscopesParser> parser_;
        strong<HoroscopeDAO> horoscopeDAO_;
    };
    
};

#endif /* horoscopesserviceimpl_h */
