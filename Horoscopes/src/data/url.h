//
//  url.h
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef url_h
#define url_h

#include "base/horobase.h"
#include <map>
#include <list>


namespace horo {
    using namespace std;
    class Url {
    public:
        Url(string url);
        ~Url(){}
        string path();
        list<pair<string,string>> queries();
    private:
        string url_;
    };
};

#endif /* url_h */
