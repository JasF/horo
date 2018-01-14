//
//  BaseNavigationController.m
//  Horoscopes
//
//  Created by Jasf on 26.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BackgroundView.h"
#import "PushAnimator.h"
#import "PopAnimator.h"
#import "UIView+Horo.h"
#include "managers/managers.h"

using namespace std;
using namespace horo;

@interface BaseNavigationController () <UINavigationControllerDelegate>
@property (assign, nonatomic) strong<ThemesManager> themesManager;
@property (strong, nonatomic) BackgroundView *backgroundView;
@property (copy, nonatomic) dispatch_block_t completion;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    _themesManager = Managers::shared().themesManager();
    NSCParameterAssert(_themesManager.get());
    
    self.view.backgroundColor = [UIColor greenColor];
    
    
    [super viewDidLoad];
    self.delegate = self;
    _backgroundView = [BackgroundView new];
    [self.view addSubview:_backgroundView];
    self.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.view sendSubviewToBack:_backgroundView];
    _backgroundView.frame = self.view.bounds;
}

#pragma mark - Public Methods
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                completion:(dispatch_block_t)completion {
    _completion = completion;
    [self pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (_themesManager->activeTheme()->nativeNavigationTransition()) {
        return nil;
    }
    NSDictionary *dictionary = @{
        @(UINavigationControllerOperationPush):[PushAnimator class],
        @(UINavigationControllerOperationPop):[PopAnimator class]
    };
    Class animatorClass = dictionary[@(operation)];
    NSCAssert(animatorClass, @"Animator for operation: %@ not found", @(operation));
    if (!animatorClass) {
        return nil;
    }
    return [animatorClass new];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if (_completion) {
        _completion();
        _completion = nil;
    }
}

@end
