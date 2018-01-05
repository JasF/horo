//
//  WebViewDialogController.h
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>

@interface WebViewDialogController : UIViewController
@property (copy, nonatomic) dispatch_block_t closeTappedBlock;
@property (copy, nonatomic) dispatch_block_t willDisappearBlock;
@property (strong, nonatomic) WKWebView *webView;
+ (instancetype)create;
@end
