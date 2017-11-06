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
            if (substr.length()) {
                result.push_back( substr );
            }
        }
        
        return result;
    }
    
    time_t timestempToTime(int64_t timestemp) {
        std::stringstream ss;
        ss << timestemp;
        time_t timenum = (time_t) strtol(ss.str().c_str(), NULL, 10);
        return timenum;
    }
    
    long long timeToTimestemp(time_t time) {
        auto unix_timestamp = std::chrono::seconds(time);
        long long nTimestemp = std::chrono::seconds(unix_timestamp).count();
        return nTimestemp;
    }
    
    long long localtime() {
        return timeToTimestemp(std::time(NULL));
    }
    
    string findInSet(std::set<std::string> storage, string pattern) {
        for (string stroke:storage) {
            if (stroke.find(pattern) != std::string::npos) {
                return stroke;
            }
        }
        return "";
    }
    
    /*
     time_t tt = system_clock::to_time_t(time);
     tm local_tm = *localtime(&tt);
     
     LOG(LS_WARNING) << "local_time: " << local_tm.tm_year + 1900 << '-';
     LOG(LS_WARNING) << local_tm.tm_mon + 1 << '-';
     LOG(LS_WARNING) << local_tm.tm_mday << ' ';
     LOG(LS_WARNING) << local_tm.tm_hour << ':';
     LOG(LS_WARNING) << local_tm.tm_min << ':';
     LOG(LS_WARNING) << local_tm.tm_sec << '\n';
     */
};

