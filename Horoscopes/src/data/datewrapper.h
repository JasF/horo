//
//  datewrapper.h
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef datewrapper_h
#define datewrapper_h

#include "base/horobase.h"

namespace horo {
  
    class DateWrapper {
    public:
        DateWrapper(int day=0, int month=0, int year=0) : day_(day),
        month_(month),
        year_(year) {}
        DateWrapper(std::string string) : DateWrapper() {
            fromString(string);
        }
        ~DateWrapper(){}
    public:
        std::string toString();
        inline int month() const { return month_; }
        inline int day() const { return day_; }
        inline int year() const { return year_; }
    private:
        void fromString(std::string string);
    private:
        int day_;
        int month_;
        int year_;
    };    
};

#endif /* datewrapper_h */
