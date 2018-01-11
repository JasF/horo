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
#include "managers/timerfactory/timerfactory.h"

namespace horo {
    class FriendsProviderFactoryImpl : public FriendsProviderFactory {
    public:
        FriendsProviderFactoryImpl(strong<WebViewServiceFactory> factory,
                                   strong<HtmlParserFactory> parserFactory,
                                   strong<TimerFactory> timerFactory)
        : factory_(factory)
        , parserFactory_(parserFactory)
        , timerFactory_(timerFactory)
        {
            SCParameterAssert(factory_.get());
            SCParameterAssert(parserFactory_.get());
            SCParameterAssert(timerFactory_.get());
        }
        ~FriendsProviderFactoryImpl() override {}
    public:
        strong<FriendsProvider> createFacebookFriendsProvider() override;
        
    private:
        strong<WebViewServiceFactory> factory_;
        strong<HtmlParserFactory> parserFactory_;
        strong<TimerFactory> timerFactory_;
    };
};

#endif /* friendsproviderfactoryimpl_h */
