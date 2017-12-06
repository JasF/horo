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
        GumboOutput* output = gumbo_parse_with_options(&kGumboDefaultOptions, text_.c_str(), text_.length());
        iterate(output->root);
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        if (birthdate_.length() && codes_.size()) {
            DateWrapper date = birthdayDetector_->timestampForDateString(birthdate_, codes_);
            string dateString = date.toString();
            if (dateString.length()) {
                results_["birthdayTimestamp"] = dateString;
            }
        }
        return results_;
    }
    
    void FacebookUserDetailParser::iterate(const GumboNode *root) {
        if (root->type == GUMBO_NODE_TEXT) {
            std::string text = root->v.text.text;
            if (text == "Дата рождения") {
                LOG(LS_ERROR)<<"!";
            }
            textsList_.push_back(text);
            if (textsList_.size() > 10) {
                textsList_.erase(textsList_.begin());
            }
            
            string backString= textsList_.back();
           // LOG(LS_WARNING) << backString;
            auto codes = birthdayDetector_->isLocalizedBirthdayString(text);
            if (codes.size()) {
                size_t count = textsList_.size();
                if (count > 1) {
                    auto it = textsList_.begin();
                    std::advance(it, count-2);
                    string birthdate = *it;
                    birthdate_ = birthdate;
                    codes_ = codes;
                    return;
                }
            }
        }
        if (root->type != GUMBO_NODE_ELEMENT) {
            return;
        }
        
        
        
        const GumboVector* root_children = &root->v.element.children;
        for (int i = 0; i < root_children->length; ++i) {
            GumboNode* child =(GumboNode *)root_children->data[i];
            iterate(child);
            if (birthdate_.length()) {
                return;
            }
        }
    }
};
