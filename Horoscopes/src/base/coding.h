//
//  coding.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef coding_h
#define coding_h

#include "base/horobase.h"

namespace horo {
  
    class Coding {
    public:
        virtual ~Coding() {}
    public:
        virtual void encode(Json::Value &coder) = 0;
        virtual void decode(Json::Value &coder) = 0;
        
        Json::Value encoded();
        Json::Value decoded();
    };
    
};

#endif /* coding_h */
