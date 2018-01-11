//
//  WebViewServiceFactoryImpl.h
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "managers/webviewservice/webviewservicefactory.h"

@interface WebViewServiceFactoryObjc : NSObject

+ (horo::WebViewServiceFactory *)sharedFactory;

@end
