//
//  WebViewControllerUIDelegate.h
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewController;

@protocol WebViewControllerUIDelegate <NSObject>
- (UIViewController *)parentViewControllerForWebViewController:(id<WebViewController>)webViewController;
- (BOOL)webViewController:(id<WebViewController>)webViewController webViewDidLoad:(NSURL *)url;
- (void)swipingToBottomFinishedInWebViewController:(id<WebViewController>)webViewController;
- (void)webViewControllerWillCloseScreenByUser:(id<WebViewController>)webViewController;
- (CGFloat)swipingTimeoutDelayForWebViewController:(id<WebViewController>)webViewController;
@end
