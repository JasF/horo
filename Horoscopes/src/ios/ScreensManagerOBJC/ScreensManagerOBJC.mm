//
//  ScreensManagerObjc.m
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "managers/screensmanager/screensmanagerimpl.h"
#import "NotificationsViewController.h"
#import "PredictionViewController.h"
#import "PushTimeViewController.h"
#import "AccountViewController.h"
#import "WelcomeViewController.h"
#import "FriendsViewController.h"
#import "ScreensManagerObjc.h"
#include "managers/managers.h"
#import "MenuViewController.h"
#import "FeedbackManager.h"
#import "Controllers.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

namespace horo {
    class ScreensManagerObjc : public ScreensManager {
    public:
        ScreensManagerObjc(strong<ScreensManager> original) : original_(original), impl_((ScreensManagerImpl *)original.get()) {
            NSCParameterAssert(original);
            
        }
        ~ScreensManagerObjc() override {}
    public:
       void showPredictionViewController(strong<Person> person, bool push = false) override {
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
           if (push) {
               viewController.hideMenuButton = YES;
               UINavigationController *controller = (UINavigationController *)delegate.window.rootViewController;
               NSCAssert([controller isKindOfClass:[UINavigationController class]], @"must be navigation controller");
               [controller pushViewController:viewController animated:YES];
               return;
           }
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
            UINavigationController *navigationController = createMenuNavigationController();
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = navigationController;
        }
        
        UINavigationController *createMenuNavigationController() {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MenuViewController"
                                                                 bundle:nil];
            
            UINavigationController *navigationController =(UINavigationController *)[storyboard
                                                                                     instantiateViewControllerWithIdentifier:@"navigationController"];
            MenuViewController *viewController = (MenuViewController *)navigationController.topViewController;
            viewController.viewModel = impl_->viewModels()->menuScreenViewModel();
            return navigationController;
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
        
        void showAccountViewController() override {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountViewController"
                                                                 bundle: nil];
            UINavigationController *navigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
            AccountViewController *accountViewController = (AccountViewController *)navigationController.topViewController;
            accountViewController.viewModel = impl_->viewModels()->accountScreenViewModel();
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = navigationController;
        }
        
        void showFriendsViewController() override {
            if (@YES.boolValue) {
                showTableSearch();
                return;
            }
        }
        
        void showFeedViewController() override {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [[FeedbackManager shared] showFeedbackController:delegate.window.rootViewController];
        }
        
        void showNotificationsViewController() override {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NotificationsViewController"
                                                                 bundle:nil];
            UINavigationController *navigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
            NotificationsViewController *viewController = (NotificationsViewController *)navigationController.topViewController;
            viewController.viewModel = impl_->viewModels()->notificationsScreenViewModel();
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = navigationController;
        }
        
        void showPushTimeViewController() override {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PushTimeViewController"
                                                                 bundle:nil];
            PushTimeViewController *viewController = (PushTimeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"viewController"];
            viewController.viewModel = impl_->viewModels()->pushTimeScreenViewModel();
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *navigationController =(UINavigationController *)delegate.window.rootViewController;
            [navigationController pushViewController:viewController animated:YES];
        }
        
    private:
        strong<ScreensManager> original_;
        ScreensManagerImpl *impl_;
    };
};

static horo::ScreensManagerObjc *sharedInstance = nullptr;
@implementation ScreensManagerOBJC
+ (void)doLoading {
    sharedInstance = new horo::ScreensManagerObjc(horo::Managers::shared().screensManager());
    horo::ScreensManagerImpl::setPrivateInstance(sharedInstance);
}

+ (UINavigationController *)createMenuNavigationController {
    return sharedInstance->createMenuNavigationController();
}

+ (MainViewController *)createMainViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainViewController"
                                                         bundle:nil];
    MainViewController *viewController = (MainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    return viewController;
}

@end
