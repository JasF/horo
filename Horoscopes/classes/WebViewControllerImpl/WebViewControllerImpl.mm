//
//  WebViewControllerImpl.m
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "WebViewControllerImpl.h"
#import <WebKit/WebKit.h>
#import "WebViewDialogController.h"
#import "UIView+Horo.h"
#include <string>

typedef NS_ENUM(NSInteger, WebViewResponseType) {
    WebViewResponseActionCallback,
    WebViewResponseDidFinishNotification
};

static CGFloat const kCyclicSwipeDuration = 0.8f;

@interface WebViewControllerImpl () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, copy) void (^webViewDidLoadCompletion)(NSString *html, NSURL *url, NSError *error);
@property (nonatomic, copy) void (^serviceBlock)(horo::WebViewServiceMessages message);
@property (strong, nonatomic) id<WebViewControllerUIDelegate> delegate;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSURL *workingURL;
@property (assign, nonatomic) CGFloat maximumContentHeight;
@property (strong, nonatomic) WebViewDialogController *dialog;
@property (strong, nonatomic) UINavigationController *dialogNavigationController;
@property (assign, nonatomic) BOOL swipingActive;
@property (strong, nonatomic) NSString *cachedPageContent;
@property (assign, nonatomic) BOOL dialogPresented;
@property (strong, nonatomic) WKNavigation *currentNavigationRequest;
@property (assign, nonatomic) WebViewResponseType responseType;
@end

@implementation WebViewControllerImpl
#pragma mark - Initialization
- (id)init {
    if (self = [super init]) {
        _dialog = [WebViewDialogController create];
        @weakify(self);
        _dialog.closeTappedBlock = ^{
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(webViewControllerWillCloseScreenByUser:)]) {
                [self.delegate webViewControllerWillCloseScreenByUser:self];
            }
        };
        _dialog.willDisappearBlock = ^{
            @strongify(self);
            self.dialogPresented = NO;
        };
        _dialogNavigationController = _dialog.navigationController;
        _webView = [_dialog webView];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _responseType = WebViewResponseDidFinishNotification;
    }
    return self;
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishSwiping) object:nil];
}

#pragma mark - WebViewController overriden methods
- (void)loadURLWithPath:(NSURL *)URL
             completion:(void(^)(NSString *html, NSURL *url, NSError *error))completion
           serviceBlock:(void(^)(horo::WebViewServiceMessages message))serviceBlock {
    DDLogInfo(@"URL: %@", URL);
    NSCParameterAssert(URL);
    NSCParameterAssert(completion);
    _workingURL = URL;
    self.webViewDidLoadCompletion = completion;
    self.serviceBlock = serviceBlock;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_workingURL];
    _cachedPageContent = nil;
    _currentNavigationRequest = [_webView loadRequest:request];
    
    UIViewController *viewController = nil;
    if ([self.delegate respondsToSelector:@selector(parentViewControllerForWebViewController:)]) {
        viewController = [self.delegate parentViewControllerForWebViewController:self];
    }
}

- (void)triggerSwipeToBottomWithCompletion:(void(^)(NSString *html, NSURL *url, NSError *error))completion {
    self.webViewDidLoadCompletion = completion;
    DDLogInfo(@"triggerSwipeToBottomWithCompletion");
    [self launchCyclicBottomSwiping];
}

- (void)setUIDelegate:(id<WebViewControllerUIDelegate>)delegate {
    _delegate = delegate;
    [self updateWebViewFrame];
}

- (void)updateWebViewFrame {
    if ([self.delegate respondsToSelector:@selector(parentViewControllerForWebViewController:)]) {
        _webView.frame = [self.delegate parentViewControllerForWebViewController:self].view.bounds;
    }
}

- (void)cancel {
    self.swipingActive = NO;
    [self.webView stopLoading];
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    DDLogDebug(@"didFinishNavigation: %@", webView.URL);
    if (navigation != _currentNavigationRequest) {
        return;
    }
    
    [self handleResponseWithURL:webView.URL force:YES];
}

- (void)showDialog {
    if (_serviceBlock) {
        _serviceBlock(horo::WebViewServiceWillShowDialog);
    }
    _dialogPresented = YES;
    [[self.delegate parentViewControllerForWebViewController:self] presentViewController:_dialogNavigationController animated:YES completion:nil];
}

- (void)hideDialog {
    if (_serviceBlock) {
        _serviceBlock(horo::WebViewServiceWillHideDialog);
    }
    _dialogPresented = NO;
    [_dialogNavigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)dialogShowed {
    return _dialogPresented;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    DDLogInfo(@"decidePolicyForNavigationAction: %@", navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    DDLogInfo(@"decidePolicyForNavigationResponse: %@", navigationResponse.response.URL);
    NSURL *url = navigationResponse.response.URL;
    [self handleResponseWithURL:url force:NO];
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)handleResponseWithURL:(NSURL *)url force:(BOOL)force {
    BOOL needsShowDialog = NO;
    if ([_delegate respondsToSelector:@selector(webViewController:webViewDidLoad:)]) {
        needsShowDialog = [_delegate webViewController:self webViewDidLoad:url];
    }
    if (needsShowDialog && !force) {
        return;
    }
    
    if (!_dialogPresented && needsShowDialog) {
        [self showDialog];
    }
    else if (_dialogPresented && !needsShowDialog) {
        [self hideDialog];
    }
    [self performSuccessCallback:YES];
    DDLogInfo(@"handleResponseWithURL: %@; webViewURL: %@; _dialogPresented: %@; needsShowDialog: %@", url, _webView.URL, @(_dialogPresented), @(needsShowDialog));
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    DDLogInfo(@"didFailNavigation URL: %@", webView.URL);
    if (navigation != _currentNavigationRequest) {
        DDLogDebug(@"ignoring didFailNavigation error on obsolete request");
        return;
    }
    if (![_webView.URL.path isEqual:_workingURL.path]) {
        return;
    }
    if (self.webViewDidLoadCompletion) {
        auto cb = self.webViewDidLoadCompletion;
        self.webViewDidLoadCompletion = nil;
        self.serviceBlock = nil;
        cb(nil, webView.URL, error);
    }
}

#pragma mark - Private Methods
- (void)performSuccessCallback:(BOOL)withClean {
    DDLogInfo(@"performSuccessCallback withClean: %@", @(withClean));
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
            CGFloat delay = [self.delegate swipingTimeoutDelayForWebViewController:self];
            [self performSelector:@selector(finishSwiping) withObject:nil afterDelay:delay];
            _cachedPageContent = object;
            auto cb = self.webViewDidLoadCompletion;
            self.webViewDidLoadCompletion = nil;
            self.serviceBlock = nil;
            cb(object, self.webView.URL, error);
        }
    }];
}

- (void)finishSwiping {
    self.swipingActive = NO;
    [_delegate swipingToBottomFinishedInWebViewController:self];
}

- (void)launchCyclicBottomSwiping {
    DDLogInfo(@"launchCyclicBottomSwiping");
    _swipingActive = YES;
    [self doCyclic:NO];
}

- (void)doCyclic:(BOOL)withNotify {
    DDLogInfo(@"doCyclic: %@", @(withNotify));
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
