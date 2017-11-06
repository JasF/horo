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
#include <vector>
#include <iostream>
#include <chrono>
#include <ctime>
#include <set>
#include "json/value.h"
#include "rtc_base/refcountedobject.h"
#include "rtc_base/scoped_ref_ptr.h"
#include "rtc_base/logging.h"
#include "base/horoasserts.h"

template<typename T>
using strong = rtc::scoped_refptr<T>;

template<typename T>
using reff = rtc::RefCountedObject<T>;

namespace horo {
    using namespace std;
    typedef Json::Value dictionary;
    class error {
    public:
        error() : code_(0) {}
        error(std::string text) : text_(text), code_(0) { text_ = text;}
        error(int code) : code_(code) {}
        error(string text, int code) : text_(text), code_(code) {}
        string text_;
        int code_;
    };
    
    vector<string> separateString(string str, char delimeter);
    time_t timestempToTime(int64_t timestemp);
    long long timeToTimestemp(time_t time);
    long long localtime();
    string findInSet(std::set<std::string> storage, string pattern);
}

#endif /* horobase_hpp */
