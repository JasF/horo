//
//  Controllers.m
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "WebViewControllerImpl.h"
#import "Controllers.h"

@implementation Controllers {
    id<WebViewController> _webViewController;
}
+ (instancetype)shared {
    static Controllers *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [Controllers new];
    });
    return sharedInstance;
}

- (id<WebViewController>)webViewController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _webViewController = [WebViewControllerImpl new];
    });
    return _webViewController;
}

@end
