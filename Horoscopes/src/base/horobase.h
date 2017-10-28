//
//  horobase.hpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef horobase_hpp
#define horobase_hpp

#include <stdio.h>
#include <map>
#include <string>
#include "json/value.h"
#include "rtc_base/refcountedobject.h"
#include "rtc_base/scoped_ref_ptr.h"
#include "rtc_base/logging.h"

template<typename T>
using strong = rtc::scoped_refptr<T>;

template<typename T>
using reff = rtc::RefCountedObject<T>;

namespace horo {
    using namespace std;
    typedef map<string, string> dictionary;
    class error {
    public:
        error(std::string text) : text_(text), code_(0) { text_ = text;}
        error(int code) : code_(code) {}
        error(string text, int code) : text_(text), code_(code) {}
        string text_;
        int code_;
    };
}

#endif /* horobase_hpp */
