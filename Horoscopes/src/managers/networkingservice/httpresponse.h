//
//  httpresponse.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef httpresponse_h
#define httpresponse_h

#include "base/horobase.h"

namespace horo {
    class _HttpResponse {
    public:
        virtual ~_HttpResponse() {}
        virtual dictionary headers()=0;
    };
    
    class HttpResponse : public
    rtc::RefCountedObject<_HttpResponse> {};
};

#endif /* httpresponse_h */
