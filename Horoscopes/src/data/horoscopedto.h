//
//  horoscopedto.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef horoscopedto_h
#define horoscopedto_h

#include "base/horobase.h"

namespace horo {
    class _HoroscopeDTO {
    public:
        virtual ~_HoroscopeDTO() {}
        
    };
    
    typedef reff<_HoroscopeDTO> HoroscopeDTO;
};

#endif /* horoscopedto_h */
