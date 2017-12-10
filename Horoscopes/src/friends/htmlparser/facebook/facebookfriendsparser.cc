//
//  facebookfriendsparser.c
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookfriendsparser.h"
#include "base/platform.h"
#include "data/url.h"

namespace horo {
    using namespace std;
    Json::Value FacebookFriendsParser::parse() {
        if (results_["results"].isArray()) {
            return results_;
        }
        cleanLatestPerson();
        persons_.clear();
        parameters_.clear();
        GumboOutput* output = gumbo_parse_with_options(&kGumboDefaultOptions, text_.c_str(), text_.length());
        iterate(output->root);
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        
        if (!latestPersonIsClean_) {
            persons_.append(latestPerson_);
            cleanLatestPerson();
        }
        
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
    
    void FacebookFriendsParser::cleanLatestPerson() {
        Json::Value cleanValue;
        latestPerson_ = cleanValue;
        latestPersonIsClean_ = true;
    }
    
    void FacebookFriendsParser::processATag(const GumboNode *root, GumboAttribute* href) {
        std::string name;
        std::string url = href->value;
        if (!url.length() || !isFriendUrl(url)) {
            return;
        }
        
        GumboAttribute *clsAttr = gumbo_get_attribute(&root->v.element.attributes, "class");
        if (clsAttr) {
            if (!strcmp(clsAttr->value, "darkTouch")) {
                if (root->v.element.children.length > 0) {
                    GumboNode* iNode = static_cast<GumboNode*>(root->v.element.children.data[0]);
                    if (iNode->v.element.tag == GUMBO_TAG_I) {
                        GumboAttribute* style;
                        if ((style = gumbo_get_attribute(&iNode->v.element.attributes, "style"))) {
                            string styleString = style->value;
                            size_t index = styleString.find("url('");
                            SCParameterAssert(index != string::npos);
                            if (index != string::npos) {
                                index += 5;
                                styleString = styleString.substr(index, styleString.size() - index);
                                index = styleString.find("'");
                                if (index != string::npos) {
                                    string imageUrl = styleString.substr(0, index);
                                    imageUrl_ = urlDecode(imageUrl);
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if (root->v.element.children.length > 0) {
            GumboNode* title_text = static_cast<GumboNode*>(root->v.element.children.data[0]);
            if (title_text->type == GUMBO_NODE_TEXT) {
                name = title_text->v.text.text;
            }
        }
        if (!name.length()) {
            return;
        }
        
        
        Json::Value person;
        person["name"] = name;
        person["personUrl"] = href->value;
        if (imageUrl_.length()) {
            person["imageUrl"] = imageUrl_;
            imageUrl_ = "";
        }
        persons_.append(person);
    }
    
    void FacebookFriendsParser::iterate(const GumboNode *root) {
        if (root->type != GUMBO_NODE_ELEMENT) {
            return;
        }
        
        if (root->v.element.tag == GUMBO_TAG_A) {
            GumboAttribute* href;
            if ((href = gumbo_get_attribute(&root->v.element.attributes, "href"))) {
                processATag(root, href);
            }
        }
        
        const GumboVector* root_children = &root->v.element.children;
        for (int i = 0; i < root_children->length; ++i) {
            GumboNode* child =(GumboNode *)root_children->data[i];
            iterate(child);
        }
    }
};
