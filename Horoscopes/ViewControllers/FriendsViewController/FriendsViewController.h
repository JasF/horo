//
//  FriendsViewController.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "viewmodels/friendsscreenviewmodel/friendsscreenviewmodel.h"

@interface FriendsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (assign, nonatomic) strong<horo::FriendsScreenViewModel> viewModel;
+ (instancetype)shared;
- (void)loadFriendsWithPath:(NSURL *)friendsUrl completion:(void(^)(NSString *html, NSURL *url, NSError *error))completion;
- (void)triggerSwipeToBottomWithCompletion:(void(^)(NSString *html, NSURL *url, NSError *error))completion;

@end
