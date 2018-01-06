//
//  horobase.cpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "horobase.h"
#include <iostream>
#include <codecvt>
#include <iostream>
#include <locale>

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
    
    tm timeToTm(time_t time) {
        tm result = *std::localtime(&time);
        return result;
    }
    
    string tmToString(struct tm *t) {
        char buffer[32];
        std::strftime(buffer, 32, "%Y-%m-%d %H:%M:%S", t);
        return buffer;
    }
    
    long long timeToTimestemp(time_t time) {
        auto unix_timestamp = std::chrono::seconds(time);
        long long nTimestemp = std::chrono::seconds(unix_timestamp).count();
        return nTimestemp;
    }
    
    long long tmToTimestamp(tm *time) {
        time_t t = mktime(time);
        return timeToTimestemp(t);
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
    
    std::string ReplaceAll(std::string str, const std::string& from, const std::string& to) {
        size_t start_pos = 0;
        while((start_pos = str.find(from, start_pos)) != std::string::npos) {
            str.replace(start_pos, from.length(), to);
            start_pos += to.length(); // Handles case where 'to' is a substring of 'from'
        }
        return str;
    }
    
    wstring toUtf16(std::string utf8) {
        std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
        std::wstring wstr = converter.from_bytes(utf8);
        return wstr;
    }
};

