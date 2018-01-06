//
//  ntp.h
//  Horoscopes
//
//  Created by Jasf on 07.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef ntp_h
#define ntp_h

#include "base/horobase.h"

namespace horo {
    
    class _Ntp {
    public:
        virtual ~_Ntp(){}
        virtual void getServerTimeWithCompletion(std::function<void(double ti)> callback)=0;
    };
    typedef reff<_Ntp> Ntp;
};


#endif /* ntp_h */

