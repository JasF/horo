//
//  WebViewControllerImpl.m
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "WebViewControllerImpl.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WKUIDelegate.h>
#import <WebKit/WKNavigationDelegate.h>
#import "WebViewDialogController.h"
#import "UIView+Horo.h"
#include <string>

static CGFloat const kCyclicSwipeDuration = 0.8f;
static CGFloat const kCancelSwipingDelay = 5.f;

@interface WebViewControllerImpl () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, copy) void (^webViewDidLoadCompletion)(NSString *html, NSURL *url, NSError *error);
@property (strong, nonatomic) id<WebViewControllerUIDelegate> delegate;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSURL *workingURL;
@property (assign, nonatomic) CGFloat maximumContentHeight;
@property (strong, nonatomic) WebViewDialogController *dialog;
@property (strong, nonatomic) UINavigationController *dialogNavigationController;
@property (assign, nonatomic) BOOL swipingActive;
@property (strong, nonatomic) NSString *cachedPageContent;
@property (assign, nonatomic) BOOL dialogPresented;
@end

@implementation WebViewControllerImpl
#pragma mark - Initialization
- (id)init {
    if (self = [super init]) {
        _dialog = [WebViewDialogController create];
        _dialogNavigationController = _dialog.navigationController;
        _webView = [_dialog webView];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return self;
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishSwiping) object:nil];
}

#pragma mark - WebViewController
- (void)loadURLWithPath:(NSURL *)URL
             completion:(void(^)(NSString *html, NSURL *url, NSError *error))completion {
    NSCParameterAssert(URL);
    NSCParameterAssert(completion);
    _workingURL = URL;
    self.webViewDidLoadCompletion = completion;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_workingURL];
    _cachedPageContent = nil;
    [_webView loadRequest:request];
    
    UIViewController *viewController = nil;
    if ([self.delegate respondsToSelector:@selector(parentViewControllerForWebViewController:)]) {
        viewController = [self.delegate parentViewControllerForWebViewController:self];
    }
    _webView.frame = viewController.view.frame;
}

- (void)triggerSwipeToBottomWithCompletion:(void(^)(NSString *html, NSURL *url, NSError *error))completion {
    self.webViewDidLoadCompletion = completion;
    [self launchCyclicBottomSwiping];
}

- (void)setUIDelegate:(id<WebViewControllerUIDelegate>)delegate {
    _delegate = delegate;
}

- (void)cancel {
    self.swipingActive = NO;
    [self.webView stopLoading];
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    BOOL needsShowDialog = NO;
    if ([_delegate respondsToSelector:@selector(webViewController:webViewDidLoad:)]) {
        needsShowDialog = [_delegate webViewController:self webViewDidLoad:webView.URL];
    }
    
    if (!_dialogPresented && needsShowDialog) {
        _dialogPresented = YES;
        [[self.delegate parentViewControllerForWebViewController:self] presentViewController:_dialogNavigationController animated:YES completion:nil];
    }
    else if (_dialogPresented && !needsShowDialog) {
        _dialogPresented = NO;
        [_dialogNavigationController dismissViewControllerAnimated:YES completion:nil];
    }
    [self performSuccessCallback:YES];
}

#pragma mark - WKNavigationDelegate
- (void)performSuccessCallback:(BOOL)withClean {
    @weakify(self);
    if (![_webView.URL.path isEqual:_workingURL.path]) {
        return;
    }
    [_webView evaluateJavaScript:@"document.documentElement.outerHTML" completionHandler:^(NSString * _Nullable object, NSError * _Nullable error) {
        @strongify(self);
        if (self.webViewDidLoadCompletion) {
            NSCAssert([object isKindOfClass:[NSString class]], @"unknown object");
            if (![object isKindOfClass:[NSString class]]) {
                return;
            }
            if ([_cachedPageContent isEqualToString:object]) {
                return;
            }
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishSwiping) object:nil];
            [self performSelector:@selector(finishSwiping) withObject:nil afterDelay:kCancelSwipingDelay];
            _cachedPageContent = object;
            auto cb = self.webViewDidLoadCompletion;
            self.webViewDidLoadCompletion = nil;
            cb(object, self.webView.URL, error);
        }
    }];
}

- (void)finishSwiping {
    self.swipingActive = NO;
    if ([_delegate respondsToSelector:@selector(swipingToBottomFinishedInWebViewController:)]) {
        [_delegate swipingToBottomFinishedInWebViewController:self];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (![_webView.URL.path isEqual:_workingURL.path]) {
        return;
    }
    if (self.webViewDidLoadCompletion) {
        auto cb = self.webViewDidLoadCompletion;
        self.webViewDidLoadCompletion = nil;
        cb(nil, webView.URL, error);
    }
}

#pragma mark - Private Methods
- (void)launchCyclicBottomSwiping {
    _swipingActive = YES;
    [self doCyclic:NO];
}

- (void)doCyclic:(BOOL)withNotify {
    if (!self.swipingActive) {
        return;
    }
    [self swipeToBottom];
    if (withNotify) {
        [self performSuccessCallback:YES];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kCyclicSwipeDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self doCyclic:YES];
    });
}

- (void)swipeToBottom {
    CGPoint point = CGPointMake(0, self.webView.scrollView.contentSize.height);
    if (point.y < 0.f) {
        point.y = 0;
    }
    [self.webView.scrollView setContentOffset:point animated:YES];
}

@end
