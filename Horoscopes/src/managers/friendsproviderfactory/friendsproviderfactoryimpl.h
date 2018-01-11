//
//  friendsproviderfactoryimpl.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsproviderfactoryimpl_h
#define friendsproviderfactoryimpl_h

#include "friendsproviderfactory.h"
#include "managers/webviewservice/webviewservicefactory.h"
#include "friends/htmlparserfactory/htmlparserfactory.h"

namespace horo {
    class FriendsProviderFactoryImpl : public FriendsProviderFactory {
    public:
        FriendsProviderFactoryImpl(strong<WebViewServiceFactory> factory,
                                   strong<HtmlParserFactory> parserFactory)
        : factory_(factory),
        parserFactory_(parserFactory)
        {
            SCParameterAssert(factory_.get());
        }
        ~FriendsProviderFactoryImpl() override {}
    public:
        strong<FriendsProvider> createFacebookFriendsProvider() override;
        
    private:
        strong<WebViewServiceFactory> factory_;
        strong<HtmlParserFactory> parserFactory_;
    };
};

#endif /* friendsproviderfactoryimpl_h */
