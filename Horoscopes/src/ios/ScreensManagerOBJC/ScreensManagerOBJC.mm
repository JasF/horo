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
#import "ScreensManagerOBJC.h"
#include "managers/managers.h"
#import "MenuViewController.h"
#import "FeedbackManager.h"
#import "Controllers.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

static NSString *kStoryboardName = @"Main";

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
        
        void showMenu() override {
            
        }
        
        void hideMenu() override {
            
        }
        
    private:
        strong<ScreensManager> original_;
        ScreensManagerImpl *impl_;
    };
};

@interface ScreensManagerOBJC ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIStoryboard *storyboard;
@property (nonatomic, strong) MainViewController *mainViewController;
@end

static horo::ScreensManagerObjc *sharedInstance = nullptr;
@implementation ScreensManagerOBJC

+ (instancetype)shared {
    static ScreensManagerOBJC *sharedInstance = nullptr;
    if (!sharedInstance) {
        sharedInstance = [ScreensManagerOBJC new];
    }
    return sharedInstance;
}

+ (void)doLoading {
    sharedInstance = new horo::ScreensManagerObjc(horo::Managers::shared().screensManager());
    horo::ScreensManagerImpl::setPrivateInstance(sharedInstance);
}

+ (UINavigationController *)createMenuNavigationController {
    return sharedInstance->createMenuNavigationController();
}

#pragma mark - Accessors
- (MainViewController *)mainViewController {
    if (!_mainViewController) {
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        [navigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"]]];
        _mainViewController = [_storyboard instantiateInitialViewController];
        _mainViewController.rootViewController = navigationController;
       // [_mainViewController.leftViewController.navigationController setNavigationBarHidden:YES animated:NO];
        [_mainViewController setupWithType:0];
        self.window.rootViewController = _mainViewController;
    }
    return _mainViewController;
}

- (UIStoryboard *)storyboard {
    if (!_storyboard) {
        _storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
    }
    return _storyboard;
}



- (UIWindow *)window {
    if (!_window) {
        _window = [UIWindow new];
        [_window makeKeyAndVisible];
        [UIView transitionWithView:_window
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:nil
                        completion:nil];
    }
    return _window;
}

- (void)setupViewControllers {
    [self mainViewController];
}

@end