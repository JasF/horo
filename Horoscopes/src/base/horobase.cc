//
//  horobase.cpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "horobase.h"
#include <iostream>

namespace horo {
    vector<string> separateString(string str, char delimeter) {
        stringstream ss( str );
        vector<string> result;
        
        while( ss.good() )
        {
            string substr;
            getline( ss, substr, delimeter );
            result.push_back( substr );
        }
        
        return result;
    }
    
    time_t timestempToTime(int64_t timestemp) {
        std::stringstream ss;
        ss << timestemp;
        time_t timenum = (time_t) strtol(ss.str().c_str(), NULL, 10);
        return timenum;
    }
    
    long long localtime() {
        auto unix_timestamp = std::chrono::seconds(std::time(NULL));
        long long nTimestemp = std::chrono::seconds(unix_timestamp).count();
        return nTimestemp;
    }
};

