//
//  HttpResponseObjc.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "managers/webviewservice/httpresponse.h"

namespace horo {
    
    class HttpResponseObjc : public HttpResponse {
    public:
        HttpResponseObjc();
        virtual ~HttpResponseObjc();
        virtual dictionary headers() override;
    };
};

@interface HttpResponseObjc : NSObject

@end
