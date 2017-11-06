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
        persons_.clear();
        parameters_.clear();
        GumboOutput* output = gumbo_parse_with_options(&kGumboDefaultOptions, text_.c_str(), text_.length());
        iterate(output->root);
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        results_["results"] = persons_;
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
    
    static set<string> excluded;
    bool isFriendUrl(string source) {
        if (!excluded.size()) {
            excluded.insert(".php");
        }

        if (!source.length() || source[0] != '/') {
            return false;
        }
        Url url(source);
        std::string path = url.path();
        auto queries = url.queries();
        if (url.path() == "profile.php" ||
            (queries.size() == 0 &&
             path.find(".php") == std::string::npos &&
             path.find("/") == std::string::npos) ) {
                return true;
            }
        return false;
    }
    
    set<string> FacebookFriendsParser::friendsUrls() {
        
        
        set<string> result;
        
        return result;
    }
    
    void FacebookFriendsParser::processATag(const GumboNode *root, GumboAttribute* cls_attr) {
        std::string name;
        std::string url = cls_attr->value;
        if (!url.length() || !isFriendUrl(url)) {
            return;
        }
        if (root->v.element.children.length > 0) {
            GumboNode* title_text = static_cast<GumboNode*>(root->v.element.children.data[0]);
            if (title_text->type == GUMBO_NODE_TEXT)
            {
                name = title_text->v.text.text;
            }
        }
        if (!name.length()) {
            return;
        }
        
        Json::Value person;
        person["name"] = name;
        person["personUrl"] = cls_attr->value;
        persons_.append(person);
    }
    
    void FacebookFriendsParser::iterate(const GumboNode *root) {
        if (root->type != GUMBO_NODE_ELEMENT) {
            return;
        }
        
        if (root->v.element.tag == GUMBO_TAG_A) {
            GumboAttribute* cls_attr;
            if ((cls_attr = gumbo_get_attribute(&root->v.element.attributes, "href"))) {
                processATag(root, cls_attr);
            }
        }
        
        const GumboVector* root_children = &root->v.element.children;
        for (int i = 0; i < root_children->length; ++i) {
            GumboNode* child =(GumboNode *)root_children->data[i];
            iterate(child);
        }
    }
};
