//
//  coding.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "coding.h"

namespace horo {
    
Json::Value Coding::encoded() {
    Json::Value value;
    encode(value);
    return value;
}

Json::Value Coding::decoded() {
    Json::Value value;
    decode(value);
    return value;
}

}
