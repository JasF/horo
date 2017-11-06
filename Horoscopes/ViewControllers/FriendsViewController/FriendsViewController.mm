//
//  FriendsViewController.m
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FriendsViewController.h"
#import <WebKit/WebKit.h>

static int kObservingContentSizeChangesContext;
static CGFloat const kRowHeight = 100;
@interface FriendsViewController () <UITableViewDelegate, UITableViewDataSource,
WKUIDelegate, WKNavigationDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WKWebView *wkWebView;
@property (nonatomic, copy) void (^webViewDidLoadCompletion)(NSString *html, NSURL *url, NSError *error);
@property (assign, nonatomic) CGFloat maximumContentHeight;
@property (assign, nonatomic) BOOL subscribed;
@property (assign, nonatomic) BOOL needSetContentOffset;
@property (assign, nonatomic) BOOL moreFriendsRequest;
@end

@implementation FriendsViewController

static FriendsViewController *staticInstance = nil;
+ (instancetype)shared {
    return staticInstance;
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
    if (self.moreFriendsRequest) {
        self.moreFriendsRequest = NO;
        [self performSuccessCallback:NO];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kObservingContentSizeChangesContext) {
        if (self.maximumContentHeight < _wkWebView.scrollView.contentSize.height) {
            self.maximumContentHeight = _wkWebView.scrollView.contentSize.height;
            CGFloat tempHeight = self.maximumContentHeight;
            self.subscribed = YES;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(delayedCheckForContentHeight:) withObject:@(tempHeight) afterDelay:0.2f];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewDidLoad {
    staticInstance = self;
    NSCParameterAssert(_viewModel);
    [super viewDidLoad];
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame];
    _wkWebView.hidden = YES;
    [self.view addSubview:_wkWebView];
    [self initializeCallbacks];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = kRowHeight;
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.separatorColor = [UIColor clearColor];
    _viewModel->updateFriendsFromFacebook();
    
    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    [self startObservingContentSizeChangesInWebView:_wkWebView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _wkWebView.frame = self.view.bounds;
}

- (void)initializeCallbacks {
    @weakify(self);
    _viewModel->authorizationUrlCallback_ = [self_weak_](std::string url, std::vector<std::string> allowedPatterns) {
        @strongify(self);
        NSString *urlString = [[NSString alloc] initWithUTF8String:url.c_str()];
        [self showUrl:urlString];
    };
}

- (void)showUrl:(NSString *)urlString {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [_wkWebView loadRequest:request];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        //case 0: return self.friendsCell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Observer
- (IBAction)friendsTapped:(id)sender {
    //_viewModel->friendsTapped();
}
- (IBAction)zodiacsTapped:(id)sender {
    //_viewModel->zodiacsTapped();
}

#pragma mark - UIWebViewDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    std::string loadedUrl = [webView.URL.absoluteString UTF8String];
    bool showWebView = _viewModel->webViewDidLoad(loadedUrl);
    self.wkWebView.hidden = !showWebView;
    [self performSuccessCallback:YES];
}

- (void)performSuccessCallback:(BOOL)withClean {
    @weakify(self);
    [_wkWebView evaluateJavaScript:@"document.documentElement.outerHTML" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        @strongify(self);
        if (self.webViewDidLoadCompletion) {
            auto cb = self.webViewDidLoadCompletion;
            self.webViewDidLoadCompletion = nil;
            cb(object, self.wkWebView.URL, error);
        }
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.webViewDidLoadCompletion) {
        auto cb = self.webViewDidLoadCompletion;
        self.webViewDidLoadCompletion = nil;
        cb(nil, webView.URL, error);
    }
}

#pragma mark -
- (void)loadFriendsWithPath:(NSURL *)friendsUrl completion:(void(^)(NSString *html, NSURL *url, NSError *error))completion {
    NSCParameterAssert(friendsUrl);
    NSCParameterAssert(completion);
    self.webViewDidLoadCompletion = completion;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:friendsUrl];
    [_wkWebView loadRequest:request];
}

- (void)triggerSwipeToBottomWithCompletion:(void(^)(NSString *html, NSURL *url, NSError *error))completion {
    self.webViewDidLoadCompletion = completion;
    self.moreFriendsRequest = YES;
    if (self.subscribed) {
        self.needSetContentOffset = YES;
    }
    else {
        [self swipeToBottom];
    }
}

- (void)swipeToBottom {
    dispatch_block_t block = ^{
        CGPoint point = CGPointMake(0, self.wkWebView.scrollView.contentSize.height);
        if (point.y < 0.f) {
            point.y = 0;
        }
        [self.wkWebView.scrollView setContentOffset:point animated:YES];
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@end
