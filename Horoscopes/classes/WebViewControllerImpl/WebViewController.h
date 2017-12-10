//
//  WebViewController.h
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewControllerUIDelegate.h"

@protocol WebViewController <NSObject>
- (void)loadURLWithPath:(NSURL *)URL
             completion:(void(^)(NSString *html, NSURL *url, NSError *error))completion;
- (void)triggerSwipeToBottomWithCompletion:(void(^)(NSString *html, NSURL *url, NSError *error))completion;
- (void)setUIDelegate:(id<WebViewControllerUIDelegate>)delegate;
- (void)cancel;
@end
