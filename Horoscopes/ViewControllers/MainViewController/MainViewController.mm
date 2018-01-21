//
//  MainViewController.m
//  LGSideMenuControllerDemo
//

#import "MainViewController.h"
#import "ViewController.h"
#import "ScreensManagerOBJC.h"
#import "MenuViewController.h"

@interface ViewPropertyAnimator : UIViewPropertyAnimator
@end

@implementation ViewPropertyAnimator
- (void)setFractionComplete:(CGFloat)fractionComplete {
    [super setFractionComplete:fractionComplete];
}
@end

@interface MainViewController ()

@property (assign, nonatomic) NSUInteger type;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) dispatch_block_t displayLinkBlock;
@property (strong, nonatomic) NSDate *animationStartDate;
@property (strong, nonatomic) UIVisualEffectView *backgroundEffectView;

@end

static CGFloat const kStartDelay = 0.5f;
static CGFloat const kBlurStartDelay = 0.25f;
static CGFloat const kBlurMaximumFraction = 0.4f;

@implementation MainViewController {
    UIVisualEffectView *_backgroundEffectView;
    UIViewPropertyAnimator *_animator;

}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkObserver)];
    }
    return _displayLink;
}

- (void)startDisplayLink {
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink {
    [self.displayLink invalidate];
    _displayLink = nil;
}

- (UIViewPropertyAnimator *)animator {
    if (!_animator) {
        @weakify(self);
        UIBlurEffect *blur = (UIBlurEffect *)self.backgroundEffectView.effect;
        self.backgroundEffectView.effect = nil;
        _animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5f curve:UIViewAnimationCurveLinear animations:^{
            @strongify(self);
            self.backgroundEffectView.effect = blur;
        }];
        [_animator startAnimation];
        
    }
    return _animator;
}

- (UIVisualEffectView *)backgroundEffectView {
    if (!_backgroundEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _backgroundEffectView = blurEffectView;
        _backgroundEffectView.frame = [UIScreen mainScreen].bounds;
        [self.view insertSubview:blurEffectView atIndex:2];
    }
    return _backgroundEffectView;
}


- (void)setDisplayLinkBlock:(dispatch_block_t)displayLinkBlock {
    if (_displayLinkBlock != displayLinkBlock) {
        if (displayLinkBlock) {
            [self startDisplayLink];
        }
        _displayLinkBlock = displayLinkBlock;
    }
    if (!_displayLinkBlock) {
        [self stopDisplayLink];
    }
}

- (void)displayLinkObserver {
    if (_displayLinkBlock) {
        _displayLinkBlock();
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    DDLogInfo(@"MainViewController allocation");
    return [super initWithCoder:aDecoder];
}

- (CGFloat)blurFractionFromPercentage:(CGFloat)percentage {
    if (percentage < kBlurStartDelay) {
        percentage = 0.f;
    }
    else {
        percentage -= kBlurStartDelay;
        percentage = percentage/(1.f-kBlurStartDelay);
    }
    return percentage*kBlurMaximumFraction;
}

- (void)showLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    self.animationStartDate = [NSDate date];
    @weakify(self);
    self.displayLinkBlock = ^{
        @strongify(self);
        NSTimeInterval currentInterval = [[NSDate date] timeIntervalSinceDate:self.animationStartDate];
        if (currentInterval > self.leftViewAnimationDuration) {
            currentInterval = self.leftViewAnimationDuration;
        }
        CGFloat percentage = 1/self.leftViewAnimationDuration*currentInterval;
        CGFloat value = [self blurFractionFromPercentage:percentage];
        [self animator].fractionComplete = value;
        DDLogInfo(@"show value: %f", value);
    };
    [super showLeftViewAnimated:animated completionHandler:^{
        @strongify(self);
        [self animator].fractionComplete = kBlurMaximumFraction;
        self.displayLinkBlock = nil;
        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (void)hideLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    @weakify(self);
    MenuViewController *menuViewController = (MenuViewController *)self.leftViewController;
    [menuViewController resetBlur];
    self.animationStartDate = [NSDate date];
    self.displayLinkBlock = ^{
        @strongify(self);
        NSTimeInterval currentInterval = [[NSDate date] timeIntervalSinceDate:self.animationStartDate];
        if (currentInterval > self.leftViewAnimationDuration) {
            currentInterval = self.leftViewAnimationDuration;
        }
        CGFloat percentage = 1/self.leftViewAnimationDuration*currentInterval;
        CGFloat value = kBlurMaximumFraction - [self blurFractionFromPercentage:percentage];
        [self animator].fractionComplete = value;
        DDLogInfo(@"percentage: %f; hide value: %f", percentage, value);
    };
    [super hideLeftViewAnimated:animated completionHandler:^{
        @strongify(self);
        [self animator].fractionComplete = 0.f;
        self.displayLinkBlock = nil;
        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (UIVisualEffectView *)effectView {
    return [self backgroundEffectView];
   // MenuViewController *menuViewController = (MenuViewController *)self.leftViewController;
   // NSCAssert([menuViewController isKindOfClass:[MenuViewController class]], @"menuViewController unknown");
   // return menuViewController.backgroundEffectView;
}

//- (UIViewPropertyAnimator *)animator {
   // MenuViewController *menuViewController = (MenuViewController *)self.leftViewController;
   // NSCAssert([menuViewController isKindOfClass:[MenuViewController class]], @"menuViewController unknown");
   // return [menuViewController animator];
//}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    [super setLeftViewController:leftViewController];
    
    /*
     0.8 ... 1
     0.1 ..... x
     
     x = 0.1 * 1 / 0.8
     
     x =  0.1 * 0.8 = 0.08
     
     x =
     
     */
    
    @weakify(self);
    self.leftViewPercentageChanged = ^(CGFloat percentage, BOOL animated) {
        @strongify(self);
        if (IsEqualFloat(percentage, 0.f)) {
           // return;
        }
        void (^changeFraction)(CGFloat fraction) = ^void(CGFloat fraction) {
            fraction = [self blurFractionFromPercentage:fraction];
            self.animator.fractionComplete = fraction;
        };
        if (animated) {
        }
        else {
            changeFraction(percentage);
        }
        CGFloat newAlpha = percentage;
        if (percentage < kStartDelay) {
            newAlpha = 0;
        }
        else {
            CGFloat newPercentage = percentage - kStartDelay;
            newAlpha = newPercentage/(1-kStartDelay);
        }
        DDLogInfo(@"perc: %@; alpha: %@", @(percentage), @(newAlpha));
        //menuViewController.backgroundEffectView.alpha = newAlpha;
    };
    // self.accessoryView = menuViewController.backgroundEffectView;
}

- (void)setupWithType:(NSUInteger)type {
    self.type = type;
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
    self.leftViewStatusBarStyle = UIStatusBarStyleLightContent;
    self.rightViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
    self.rightViewStatusBarStyle = UIStatusBarStyleLightContent;
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];

    if (!self.isLeftViewStatusBarHidden) {
        self.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super rightViewWillLayoutSubviewsWithSize:size];

    if (!self.isRightViewStatusBarHidden ||
        (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape &&
         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
         UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation))) {
        self.rightView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (BOOL)isLeftViewStatusBarHidden {
    if (self.type == 8) {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    }

    return super.isLeftViewStatusBarHidden;
}

- (BOOL)isRightViewStatusBarHidden {
    if (self.type == 8) {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    }

    return super.isRightViewStatusBarHidden;
}

- (void)dealloc {
    NSLog(@"MainViewController deallocated");
}

@end
