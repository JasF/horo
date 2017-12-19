//
//  ScreensManagerObjc.m
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "ScreensManagerObjc.h"
#include "managers/screensmanager/screensmanagerimpl.h"
#import "PredictionViewController.h"
#import "WelcomeViewController.h"
#include "managers/managers.h"
#import "MenuViewController.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FriendsViewController.h"
#import "Controllers.h"

namespace horo {
    class ScreensManagerObjc : public ScreensManager {
    public:
        ScreensManagerObjc(strong<ScreensManager> original) : original_(original), impl_((ScreensManagerImpl *)original.get()) {
            NSCParameterAssert(original);
            
        }
        ~ScreensManagerObjc() override {}
    public:
       void showPredictionViewController(strong<Person> person) override {
           SCParameterAssert( !person.get() || (person.get() && person->zodiac().get()) );
           if (person.get() && !person->zodiac().get()) {
               return;
           }
           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PredictionViewController"
                                                                bundle:nil];
            
           UINavigationController *navigationController =(UINavigationController *)[storyboard
                                                           instantiateViewControllerWithIdentifier:@"navigationController"];
           UIPageViewController *pageViewController = (UIPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HoroscopesPageViewController"];
           PredictionViewController *viewController = (PredictionViewController *)navigationController.topViewController;
           viewController.horoscopesPageViewController = pageViewController;
           viewController.viewModel = impl_->viewModels()->predictionScreenViewModel(person);
            
           AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
           delegate.window.rootViewController = navigationController;
        }
        
        void showPredictionViewController() override {
            showPredictionViewController(nullptr);
        }
        void showWelcomeViewController() override {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WelcomeViewController"
                                                                 bundle: nil];
            
            UINavigationController *navigationController =(UINavigationController *)[storyboard
                                                                                     instantiateViewControllerWithIdentifier:@"navigationController"];
            WelcomeViewController *viewController = (WelcomeViewController *)navigationController.topViewController;
            viewController.viewModel = impl_->viewModels()->helloScreenViewModel();
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *navController = (UINavigationController *)delegate.window.rootViewController;
            if ([navController isKindOfClass:[UINavigationController class]]) {
                CGRect frame = navController.view.bounds;
                frame.origin.y = frame.size.height;
                viewController.view.frame = frame;
                [navController.view addSubview:viewController.view];
                [viewController didMoveToParentViewController:navController];
                frame.origin.y = 0.f;
                viewController.view.frame = frame;
                [viewController lockSelf];
            }
            else {
                delegate.window.rootViewController = navigationController;
            }
        }
        void showMenuViewController(bool animated) override {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MenuViewController"
                                                                 bundle:nil];
            
            UINavigationController *navigationController =(UINavigationController *)[storyboard
                                                                                     instantiateViewControllerWithIdentifier:@"navigationController"];
            MenuViewController *viewController = (MenuViewController *)navigationController.topViewController;
            viewController.viewModel = impl_->viewModels()->menuScreenViewModel();
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = navigationController;
        }
        
        void showTableSearch() {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendsViewController"
                                                                 bundle: nil];
            
            UINavigationController *navigationController =(UINavigationController *)[storyboard
                                                                                     instantiateViewControllerWithIdentifier:@"RootNavController"];
            FriendsViewController *viewController = (FriendsViewController *)navigationController.topViewController;
            viewController.viewModel = impl_->viewModels()->friendsScreenViewModel();
            viewController.webViewController = [Controllers shared].webViewController;
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = navigationController;
        }
        
        void showAccountViewController() {
            
        }
        
        /*
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountViewController"
                                                             bundle: nil];
        UINavigationController *navigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
        AccountViewController *accountViewController = (AccountViewController *)navigationController.topViewController;
        accountViewController.viewModel = impl_->viewModels()->accountScreenViewModel();
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = navigationController;
        */
        void showFriendsViewController() override {
            if (@YES.boolValue) {
                showTableSearch();
                return;
            }
        }
    private:
        strong<ScreensManager> original_;
        ScreensManagerImpl *impl_;
    };
};

@implementation ScreensManagerObjc
+ (void)doLoading {
    static horo::ScreensManagerObjc *sharedInstance = nullptr;
    sharedInstance = new horo::ScreensManagerObjc(horo::Managers::shared().screensManager());
    horo::ScreensManagerImpl::setPrivateInstance(sharedInstance);
}

@end
