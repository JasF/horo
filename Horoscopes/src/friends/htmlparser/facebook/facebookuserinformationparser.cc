//
//  facebookuserinformationparser.c
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookuserinformationparser.h"

namespace horo {
    using namespace std;
    Json::Value FacebookUserInformationParser::parse() {
        if (results_["url"].asString().length()) {
            return results_;
        }
        parameters_.clear();
        hrefs_.clear();
        GumboOutput* output = gumbo_parse_with_options(&kGumboDefaultOptions, text_.c_str(), text_.length());
        iterate(output->root);
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        std::string url = friendsUrl();
        if (url.length()) {
            results_["url"] = url;
        }
        return results_;
    }
    
    string FacebookUserInformationParser::friendsUrl() {
        string friends = findInSet(hrefs_, "friends");
        return friends;
    }
    
    
    void FacebookUserInformationParser::iterate(const GumboNode *root) {
        if (root->type != GUMBO_NODE_ELEMENT) {
            return;
        }
        
        GumboAttribute* cls_attr;
        if ((cls_attr = gumbo_get_attribute(&root->v.element.attributes, "href"))) {
            hrefs_.insert(cls_attr->value);
        }
        
        const GumboVector* root_children = &root->v.element.children;
        for (int i = 0; i < root_children->length; ++i) {
            GumboNode* child =(GumboNode *)root_children->data[i];
            iterate(child);
        }
    }
};
