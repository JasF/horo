//
//  UIViewControllerInjector.m
//  Horoscopes
//
//  Created by Jasf on 13.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "UIViewControllerInjector.h"
#import <JGMethodSwizzler/JGMethodSwizzler.h>
#include "managers/managers.h"
#import "managers/screensmanager/screensmanagerimpl.h"

@interface UIViewControllerInjector ()
- (void)injectViewModel:(NSValue *)value;
@end

@implementation UIViewControllerInjector
typedef void (^InjectorBlock)(UIViewController *);
+ (void)doLoading {
    auto screensManager = horo::Managers::shared().screensManager();
    horo::ScreensManagerImpl *impl =(horo::ScreensManagerImpl *)screensManager.get();
    NSDictionary *dictionary = @{@"MenuViewController":^(UIViewController *viewController){
        auto viewModel = impl->viewModels()->menuScreenViewModel();
        [viewController performSelector:@selector(injectViewModel:) withObject:[NSValue valueWithPointer:&viewModel]];
    }};
    [UIViewController swizzleInstanceMethod:@selector(viewDidLoad) withReplacement:JGMethodReplacementProviderBlock {
        //return a replacement block
        return JGMethodReplacement(void, UIViewController *, int arg) {
            NSString *className = NSStringFromClass([self class]);
            InjectorBlock configurationBlock = dictionary[className];
            if (configurationBlock) {
                configurationBlock(self);
            }
            JGOriginalImplementation(int, arg);
        };
    }];
}

- (void)injectViewModel:(NSValue *)value{}
@end
