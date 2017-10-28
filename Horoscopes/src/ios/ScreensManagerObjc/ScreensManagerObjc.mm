//
//  ScreensManagerObjc.m
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "ScreensManagerObjc.h"
#include "managers/screensmanager/screensmanagerimpl.h"
#include "managers/managers.h"
#import <UIKit/UIKit.h>
#import "PredictionViewController.h"
#import "AppDelegate.h"

namespace horo {
    class ScreensManagerObjc : public ScreensManager {
    public:
        ScreensManagerObjc(strong<ScreensManager> original) : original_(original), impl_((ScreensManagerImpl *)original.get()) {
            NSCParameterAssert(original);
            
        }
        ~ScreensManagerObjc() override {}
    public:
        void showPredictionViewController() override {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PredictionViewController"
                                                                     bundle: nil];
            
            UINavigationController *navigationController =(UINavigationController *)[storyboard
                                                            instantiateViewControllerWithIdentifier:@"navigationController"];
            PredictionViewController *viewController = (PredictionViewController *)navigationController.topViewController;
            viewController.viewModel = impl_->viewModels()->predictionScreenViewModel();
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *tnc = (UINavigationController *)delegate.window.rootViewController;
            if ([tnc isKindOfClass:[UINavigationController class]]) {
                [tnc pushViewController:viewController animated:YES];
            }
            else {
                delegate.window.rootViewController = navigationController;
            }
        }
    private:
        strong<ScreensManager> original_;
        ScreensManagerImpl *impl_;
    };
};

@implementation ScreensManagerObjc
+ (void)load {
    static horo::ScreensManagerObjc *sharedInstance = nullptr;
    sharedInstance = new horo::ScreensManagerObjc(horo::Managers::shared().screensManager());
    horo::ScreensManagerImpl::setPrivateInstance(sharedInstance);
}

@end
