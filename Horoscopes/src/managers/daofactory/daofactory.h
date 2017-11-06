//
//  daofactory.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef daofactory_h
#define daofactory_h

#include "base/horobase.h"
#include "managers/horoscopedao/horoscopedao.h"
#include "managers/persondao/persondao.h"

namespace horo {
    
    class _DAOFactory {
    public:
        virtual ~_DAOFactory() {}
        virtual strong<HoroscopeDAO> createHoroscopeDAO()=0;
        virtual strong<PersonDAO> createPersonDAO()=0;
    };
    
    typedef reff<_DAOFactory> DAOFactory;
    
};

#endif /* daofactory_h */
