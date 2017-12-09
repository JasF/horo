//
//  WebViewControllerUIDelegate.h
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewControllerUIDelegate <NSObject>
- (UIViewController *)parentViewController;
- (BOOL)webViewDidLoad:(NSURL *)url;
@end
