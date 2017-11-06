//
//  url.c
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "url.h"

namespace horo {
    using namespace std;
Url::Url(string url)
    : url_(url) {
    
}
 
string Url::path() {
    size_t index = 0;
    for (int i =0;i<1;++i) {
        index = url_.find("/", index);
        if (index == string::npos) {
            
            return "";
        }
    }
    ++index;
    string right = url_.substr(index, url_.length() - index);
    index = right.find("?");
    if (index == string::npos) {
        return right;
    }
    string result = right.substr(0, index);
    return result;
}

list<pair<string,string>> Url::queries() {
    list<pair<string,string>> result;
    size_t index = url_.find("?");
    if (index == string::npos) {
        return result;
    }
    string queriesString = url_.substr(index, url_.length() - index);
    vector<string> vctr = separateString(queriesString, '&');
    for (auto fullQuery : vctr) {
        vector<string> keyvalue = separateString(fullQuery, '=');
        if (keyvalue.size() != 2) {
            continue;
        }
        result.push_back(pair<string,string>(keyvalue[0], keyvalue[1]));
    }
    return result;
}

};
