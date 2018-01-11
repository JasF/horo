//
//  WebViewController.h
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewControllerUIDelegate.h"
#include "managers/webviewservice/webviewservice.h"

@protocol WebViewController <NSObject>
- (void)loadURLWithPath:(NSURL *)URL
             completion:(void(^)(NSString *html, NSURL *url, NSError *error))completion
           serviceBlock:(void(^)(horo::WebViewServiceMessages message))serviceBlock;
- (void)triggerSwipeToBottomWithCompletion:(void(^)(NSString *html, NSURL *url, NSError *error))completion;
- (void)setUIDelegate:(id<WebViewControllerUIDelegate>)delegate;
- (void)cancel;
- (void)showDialog;
- (void)hideDialog;
- (BOOL)dialogShowed;
@end
