//
//  WebViewDialogController.m
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "WebViewDialogController.h"
#import "UIView+Horo.h"
#import <WebKit/WKWebView.h>

@interface WebViewDialogController ()
@property (strong, nonatomic) IBOutlet UIView *containerView;
@end

@implementation WebViewDialogController

#pragma mark - Initialization
+ (instancetype)create {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WebViewDialogController"
                                                         bundle:nil];
    UINavigationController *navigationController =(UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    WebViewDialogController *viewController = (WebViewDialogController *)navigationController.topViewController;
    [viewController loadViewIfNeeded];
    return viewController;
}

- (void)viewDidLoad {
    DDLogInfo(@"viewDidLoad");
    [super viewDidLoad];
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [_containerView horo_addFillingSubview:_webView];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    DDLogInfo(@"viewWillDisappear");
    [super viewWillDisappear:animated];
    if (_willDisappearBlock) {
        _willDisappearBlock();
    }
}

#pragma mark - Observers
- (IBAction)closeTapped:(id)sender {
    DDLogInfo(@"closeTapped");
    if (_closeTappedBlock) {
        _closeTappedBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
