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
    class HttpResponse {
    public:
        virtual ~HttpResponse() {}
        virtual dictionary headers()=0;
    };
};

#endif /* httpresponse_h */
