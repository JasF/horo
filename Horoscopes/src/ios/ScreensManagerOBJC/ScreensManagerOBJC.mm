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
#import "BaseNavigationController.h"
#import "PushTimeViewController.h"
#import "AccountViewController.h"
#import "WelcomeViewController.h"
#import "FriendsViewController.h"
#import "ScreensManagerOBJC.h"
#include "managers/managers.h"
#import "MenuViewController.h"
#import "FeedbackManager.h"
#import "ViewController.h"
#import "Controllers.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

static NSInteger const kSlideMenuActivationMode = 8;

@interface ScreensManagerOBJC () {
@public
    horo::ScreensManagerImpl *impl_;
}
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIStoryboard *storyboard;
@property (nonatomic, strong) MainViewController *mainViewController;
@property (nonatomic, strong) BaseNavigationController *navigationController;

- (void)showPredictionViewController:(strong<horo::Person>)person push:(BOOL)push;
- (void)showNotificationsViewController;
- (void)showFriendsViewController;
- (void)showAccountViewController;
@end

static NSString *kStoryboardName = @"Main";

namespace horo {
    class ScreensManagerObjc : public ScreensManager {
    public:
        ScreensManagerObjc(strong<ScreensManager> original) : original_(original), impl_((ScreensManagerImpl *)original.get()) {
            NSCParameterAssert(original);
            [ScreensManagerOBJC shared]->impl_ = impl_;
        }
        ~ScreensManagerObjc() override {}
    public:
       void showPredictionViewController(strong<Person> person, bool push = false) override {
           SCParameterAssert( !person.get() || (person.get() && person->zodiac().get()) );
           if (person.get() && !person->zodiac().get()) {
               return;
           }
           [[ScreensManagerOBJC shared] showPredictionViewController:person push:push];
        }
        
        void showPredictionViewController() override {
            showPredictionViewController(Managers::shared().coreComponents()->person_);
        }
        
        void showWelcomeViewController() override {
            [[ScreensManagerOBJC shared] showWelcomeViewController];
        }
        void showMenuViewController(bool animated) override {
            [[ScreensManagerOBJC shared] showMenuViewController];
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
            [[ScreensManagerOBJC shared] showFriendsViewController];
        }
        
        void showAccountViewController() override {
            [[ScreensManagerOBJC shared] showAccountViewController];
        }
        
        void showFriendsViewController() override {
            if (@YES.boolValue) {
                showTableSearch();
                return;
            }
        }
        
        void showFeedViewController() override {
            [[FeedbackManager shared] showFeedbackController:[ScreensManagerOBJC shared].window.rootViewController];
        }
        
        void showNotificationsViewController() override {
            [[ScreensManagerOBJC shared] showNotificationsViewController];
        }
        
        void showPushTimeViewController() override {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PushTimeViewController"
                                                                 bundle:nil];
            PushTimeViewController *viewController = (PushTimeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"viewController"];
            viewController.viewModel = impl_->viewModels()->pushTimeScreenViewModel();
            UINavigationController *navigationController =[ScreensManagerOBJC shared].navigationController;
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

static horo::ScreensManagerObjc *sharedInstance = nullptr;
@implementation ScreensManagerOBJC {
}

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
        self.navigationController = navigationController;
        [navigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"]]];
        _mainViewController = [_storyboard instantiateInitialViewController];
        _mainViewController.rootViewController = navigationController;
       // [_mainViewController.leftViewController.navigationController setNavigationBarHidden:YES animated:NO];
        [_mainViewController setupWithType:kSlideMenuActivationMode];
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

- (void)showWelcomeViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WelcomeViewController"
                                                         bundle: nil];
    UINavigationController *navigationController =(UINavigationController *)[storyboard
                                                                             instantiateViewControllerWithIdentifier:@"navigationController"];
    WelcomeViewController *viewController = (WelcomeViewController *)navigationController.topViewController;
    viewController.viewModel = impl_->viewModels()->helloScreenViewModel();
    [self.navigationController setNavigationBarHidden:YES];
    [self pushViewController:viewController];
}

- (BOOL)canIgnorePushingViewController:(Class)cls person:(strong<horo::Person>)person {
    if ([[self.navigationController.topViewController class] isEqual:[PredictionViewController class]] && [cls isEqual:[PredictionViewController class]]) {
        PredictionViewController *viewController =(PredictionViewController *)self.navigationController.topViewController;
        if (viewController.viewModel->model()->zodiac()->type() == person->zodiac()->type()) {
            if (self.mainViewController.isLeftViewVisible) {
                [self.mainViewController hideLeftViewAnimated];
            }
            return YES;
        }
    }
    else if ([[self.navigationController.topViewController class] isEqual:cls]) {
        return YES;
    }
    return NO;
}

- (BOOL)canIgnorePushingViewController:(Class)cls {
    return [self canIgnorePushingViewController:cls person:nil];
}

- (void)showPredictionViewController:(strong<horo::Person>)person push:(BOOL)push {
    [self.mainViewController hideLeftViewAnimated];
    if ([self canIgnorePushingViewController:[PredictionViewController class] person:person]) {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PredictionViewController" bundle:nil];
    UINavigationController *navigationController =(UINavigationController *)[storyboard
    instantiateViewControllerWithIdentifier:@"navigationController"];
    UIPageViewController *pageViewController = (UIPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HoroscopesPageViewController"];
    PredictionViewController *viewController = (PredictionViewController *)navigationController.topViewController;
    viewController.horoscopesPageViewController = pageViewController;
    viewController.viewModel = impl_->viewModels()->predictionScreenViewModel(person);
    [self.navigationController setNavigationBarHidden:NO];
    if (push) {
        viewController.hideMenuButton = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        [self pushViewController:viewController];
    }
}

- (BOOL)allowReplaceWithViewController:(UIViewController *)viewController {
    if (!self.navigationController.viewControllers.count) {
        return YES;
    }
    if (self.navigationController.viewControllers.count == 1 &&
        [self.navigationController.viewControllers.firstObject isKindOfClass:[ViewController class]]) {
        return YES;
    }
    return NO;
}

- (void)pushViewController:(UIViewController *)viewController {
    if ([self allowReplaceWithViewController:viewController]) {
        self.navigationController.viewControllers = @[viewController];
    }
    else {
        [self.navigationController pushViewController:viewController animated:YES completion:^{
            if (self.navigationController.viewControllers.count > 1) {
                self.navigationController.viewControllers = @[viewController];
            }
        }];
    }
}

- (void)showMenuViewController {
    [self.mainViewController showLeftViewAnimated:YES completionHandler:^{
        DDLogInfo(@"dlog");
    }];
}

- (void)showNotificationsViewController {
    [self.mainViewController hideLeftViewAnimated];
    if ([self canIgnorePushingViewController:[NotificationsViewController class]]) {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NotificationsViewController"
                                                         bundle:nil];
    UINavigationController *navigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    NotificationsViewController *viewController = (NotificationsViewController *)navigationController.topViewController;
    viewController.viewModel = impl_->viewModels()->notificationsScreenViewModel();
    [self pushViewController:viewController];
}

- (void)showFriendsViewController {
    [self.mainViewController hideLeftViewAnimated];
    if ([self canIgnorePushingViewController:[FriendsViewController class]]) {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FriendsViewController"
                                                     bundle: nil];

    UINavigationController *navigationController =(UINavigationController *)[storyboard
                                                                         instantiateViewControllerWithIdentifier:@"RootNavController"];
    FriendsViewController *viewController = (FriendsViewController *)navigationController.topViewController;
    viewController.viewModel = impl_->viewModels()->friendsScreenViewModel();
    [self pushViewController:viewController];
}

- (void)showAccountViewController {
    [self.mainViewController hideLeftViewAnimated];
    if ([self canIgnorePushingViewController:[AccountViewController class]]) {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountViewController"
                                                         bundle: nil];
    UINavigationController *navigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    AccountViewController *viewController = (AccountViewController *)navigationController.topViewController;
    viewController.viewModel = impl_->viewModels()->accountScreenViewModel();
    [self pushViewController:viewController];
}

@end
