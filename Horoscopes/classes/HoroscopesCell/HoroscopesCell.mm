//
//  HoroscopesCell.m
//  Horoscopes
//
//  Created by Jasf on 02.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "HoroscopesCell.h"
#import "PredictionContentViewController.h"
#import "UIView+TKGeometry.h"

static NSInteger const kTodayTabIndex = 1;

@interface HoroscopesCell () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSMutableDictionary *viewControllers;
@end

@implementation HoroscopesCell

#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
    _viewControllers = [NSMutableDictionary new];
}

- (void)dealloc {
    
}

#pragma mark - Accessors
- (void)setPageViewController:(UIPageViewController *)pageViewController {
    _pageViewController = pageViewController;
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
}

- (void)setTexts:(NSArray *)texts {
    NSCParameterAssert(_pageViewController);
    _texts = texts;
    NSInteger index = (texts.count > kTodayTabIndex) ? kTodayTabIndex : 0;
    PredictionContentViewController *viewController = [self viewControllerByIndex:index];
    _heightConstraint.constant = viewController.view.height;
    [_pageViewController setViewControllers:@[viewController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(PredictionContentViewController *)viewController {
    if (!viewController.index) {
        return nil;
    }
    return [self viewControllerByIndex:viewController.index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(PredictionContentViewController *)viewController {
    if (viewController.index >= _texts.count-1) {
        return nil;
    }
    return [self viewControllerByIndex:viewController.index + 1];
}


#pragma mark - UIPageViewControllerDelegate

#pragma mark - Private Methods
- (PredictionContentViewController *)allocateViewControllerWithIndex:(NSInteger)index {
    NSCAssert(index < _texts.count, @"index out of bounds");
    if (index >= _texts.count) {
        return nil;
    }
    PredictionContentViewController *viewController = [[PredictionContentViewController alloc] initWithNibName:@"PredictionContentViewController" bundle:nil];
    [viewController loadViewIfNeeded];
    viewController.index = index;
    NSString *text = _texts[index];
    [viewController setText:text width:self.parentViewController.view.width];
    [_viewControllers setObject:viewController forKey:@(index)];
    return viewController;
}

- (PredictionContentViewController *)viewControllerByIndex:(NSInteger)index {
    PredictionContentViewController *resultViewController = _viewControllers[@(index)];
    if (!resultViewController) {
        resultViewController = [self allocateViewControllerWithIndex:index];
    }
    return resultViewController;
}

@end