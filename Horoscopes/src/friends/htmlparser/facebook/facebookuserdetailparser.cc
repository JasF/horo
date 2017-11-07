//
//  facebookuserdetailparser.c
//  Horoscopes
//
//  Created by Jasf on 07.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookuserdetailparser.h"

namespace horo {
    using namespace std;
    Json::Value FacebookUserDetailParser::parse() {
        if (results_["url"].asString().length()) {
            return results_;
        }
        textsList_.clear();
        parameters_.clear();
        hrefs_.clear();
        GumboOutput* output = gumbo_parse_with_options(&kGumboDefaultOptions, text_.c_str(), text_.length());
        iterate(output->root);
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        for (auto url:hrefs_) {
            if (url.find("about?") != std::string::npos) {
               // results_["url"] = url;
              //  break;
            }
        }
        return results_;
    }
    
    void FacebookUserDetailParser::iterate(const GumboNode *root) {
        if (root->type == GUMBO_NODE_TEXT) {
            
            textsList_.push_back(root->v.text.text);
            string backString= textsList_.back();
           // LOG(LS_WARNING) << backString;
            if (backString == birthdayDateDetectorString()) {
                size_t count = textsList_.size();
                if (count > 1) {
                    auto it = textsList_.begin();
                    std::advance(it, count-2);
                    string birthdate = *it;
                    LOG(LS_ERROR) << "birthdate: " << birthdate;
                }
            }
        }
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
    
    string FacebookUserDetailParser::birthdayDateDetectorString() {
        return "Дата рождения";
    }
};


