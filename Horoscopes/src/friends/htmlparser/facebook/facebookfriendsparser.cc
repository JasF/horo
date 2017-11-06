//
//  facebookfriendsparser.c
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookfriendsparser.h"
#include "data/url.h"

static const char *kFriendPattern = "fref=fr_tab";

namespace horo {
    using namespace std;
    Json::Value FacebookFriendsParser::parse() {
        if (results_["results"].isArray()) {
            return results_;
        }
        parameters_.clear();
        hrefs_.clear();
        GumboOutput* output = gumbo_parse_with_options(&kGumboDefaultOptions, text_.c_str(), text_.length());
        iterate(output->root);
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        Json::Value array;
        for (auto path :friendsUrls()) {
            array.append(path);
        }
        results_["results"] = array;
        return results_;
    }
    
    bool stringContainSubstring(string source, set<string> substrings) {
        for (auto str : substrings) {
            if (source.find(str) != std::string::npos) {
                return true;
            }
        }
        return false;
    }
    
    set<string> FacebookFriendsParser::friendsUrls() {
        
        set<string> excluded;
        excluded.insert(".php");
        
        set<string> result;
        for (auto source :hrefs_) {
            if (!source.length() || source[0] != '/') {
                continue;
            }
            Url url(source);
            std::string path = url.path();
            auto queries = url.queries();
            if (url.path() == "profile.php" ||
                (queries.size() == 0 &&
                 path.find(".php") == std::string::npos &&
                 path.find("/") == std::string::npos) ) {
                result.insert(source);
            }
        }
        return result;
    }
    
    
    void FacebookFriendsParser::iterate(const GumboNode *root) {
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
