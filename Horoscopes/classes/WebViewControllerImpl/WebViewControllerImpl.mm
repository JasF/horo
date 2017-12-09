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

static int kObservingContentSizeChangesContext;

@interface WebViewControllerImpl () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, copy) void (^webViewDidLoadCompletion)(NSString *html, NSURL *url, NSError *error);
@property (strong, nonatomic) id<WebViewControllerUIDelegate> delegate;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSURL *workingURL;
@property (assign, nonatomic) BOOL moreBottomSwipe;
@property (assign, nonatomic) BOOL subscribed;
@property (assign, nonatomic) BOOL needSetContentOffset;
@property (assign, nonatomic) CGFloat maximumContentHeight;
@property (strong, nonatomic) WebViewDialogController *dialog;
@end

@implementation WebViewControllerImpl
#pragma mark - Initialization
- (id)init {
    if (self = [super init]) {
        _dialog = [WebViewDialogController create];
        _webView = [_dialog webView];
        _webView.hidden = YES;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return self;
}

- (void)dealloc {
    [self stopObservingContentSizeChangesInWebView:_webView];
}

#pragma mark - WebViewController
- (void)loadURLWithPath:(NSURL *)URL
             completion:(void(^)(NSString *html, NSURL *url, NSError *error))completion {
    NSCParameterAssert(URL);
    NSCParameterAssert(completion);
    _workingURL = URL;
    self.webViewDidLoadCompletion = completion;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_workingURL];
    [_webView loadRequest:request];
}

- (void)triggerSwipeToBottomWithCompletion:(void(^)(NSString *html, NSURL *url, NSError *error))completion {
    self.webViewDidLoadCompletion = completion;
    self.moreBottomSwipe = YES;
    if (self.subscribed) {
        self.needSetContentOffset = YES;
    }
    else {
        [self swipeToBottom];
    }
}

- (void)setUIDelegate:(id<WebViewControllerUIDelegate>)delegate {
    _delegate = delegate;
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.delegate.parentViewController presentViewController:_dialog.navigationController animated:YES completion:nil];
    [self performSuccessCallback:YES];
}

#pragma mark - WKNavigationDelegate


#pragma mark - UIWebViewDelegate

- (void)performSuccessCallback:(BOOL)withClean {
    @weakify(self);
    if (![_webView.URL.path isEqual:_workingURL.path]) {
        return;
    }
    [_webView evaluateJavaScript:@"document.documentElement.outerHTML" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        @strongify(self);
        if (self.webViewDidLoadCompletion) {
            auto cb = self.webViewDidLoadCompletion;
            self.webViewDidLoadCompletion = nil;
            cb(object, self.webView.URL, error);
        }
    }];
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

- (void)startObservingContentSizeChangesInWebView:(WKWebView *)webView {
    [webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:&kObservingContentSizeChangesContext];
}

- (void)stopObservingContentSizeChangesInWebView:(WKWebView *)webView {
    [webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:&kObservingContentSizeChangesContext];
}

- (void)delayedCheckForContentHeight:(NSNumber *)tempHeight {
    if (![@(_maximumContentHeight) isEqual:tempHeight]) {
        return;
    }
    self.subscribed = NO;
    if (self.needSetContentOffset) {
        self.needSetContentOffset = NO;
        [self swipeToBottom];
    }
    if (self.moreBottomSwipe) {
        self.moreBottomSwipe = NO;
        [self performSuccessCallback:NO];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kObservingContentSizeChangesContext) {
        if (self.maximumContentHeight < _webView.scrollView.contentSize.height) {
            self.maximumContentHeight = _webView.scrollView.contentSize.height;
            CGFloat tempHeight = self.maximumContentHeight;
            self.subscribed = YES;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(delayedCheckForContentHeight:) withObject:@(tempHeight) afterDelay:0.2f];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Private Methods
- (void)swipeToBottom {
    
}

@end
