//
//  FriendsViewController.m
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FriendsViewController.h"
#import <WebKit/WebKit.h>

static CGFloat const kRowHeight = 100;


@interface FriendsViewController () <UITableViewDelegate, UITableViewDataSource,
UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSCParameterAssert(_viewModel);
    [self initializeCallbacks];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = kRowHeight;
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.separatorColor = [UIColor clearColor];
    _viewModel->updateFriendsFromFacebook();
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
    _webView.hidden = NO;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
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
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"requesting |&^*($| url: %@", webView.request.URL);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    std::string loadedUrl = [webView.request.URL.absoluteString UTF8String];
    BOOL canContinue = _viewModel->webViewDidLoad(loadedUrl);
    if (!canContinue) {
        _webView.hidden = YES;
        [_webView stopLoading];
    }
    /*
    NSLog(@"did-load |&^*($| url: %@", webView.request.URL);
    NSString *yourHTMLSourceCodeString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSLog(@"length: %@", @([yourHTMLSourceCodeString length]));
    */
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error {
    
}

@end
