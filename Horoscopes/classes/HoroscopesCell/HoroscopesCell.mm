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

@interface HoroscopesCell () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSMutableDictionary *viewControllers;
@property (weak, nonatomic) PredictionContentViewController *selectedViewController;
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
    [[self scrollView] setDelegate:nil];
    _pageViewController = pageViewController;
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    [[self scrollView] setDelegate:self];
}

- (void)setTexts:(NSArray *)texts {
    NSCParameterAssert(_pageViewController);
    _texts = texts;
    NSInteger index = (texts.count > kTodayTabIndex) ? kTodayTabIndex : 0;
    PredictionContentViewController *viewController = [self viewControllerByIndex:index];
    _selectedViewController = viewController;
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
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    PredictionContentViewController *viewController = _pageViewController.viewControllers.firstObject;
    if ([_selectedViewController isEqual:viewController]) {
        return;
    }
    NSInteger previous = _selectedViewController.index;
    _selectedViewController = viewController;
    if (_selectedPageChanged) {
        _selectedPageChanged(previous, _selectedViewController.index);
    }
}

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

- (UIScrollView *)scrollView {
    for (UIView *view in _pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            return(UIScrollView *)view;
        }
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    Direction direction = (scrollView.contentOffset.x > scrollView.width) ? DirectionForwardToLeft : DirectionBackToRight;
    CGFloat delta = (direction == DirectionForwardToLeft) ? scrollView.contentOffset.x - scrollView.width : scrollView.width - scrollView.contentOffset.x;
    if (IsEqualFloat(0, delta)) {
        return;
    }
    CGFloat percentage = delta / scrollView.width;
    if (_draggingProgress) {
        _draggingProgress(percentage, direction);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidEndDecelerating");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation");
    // after finish custom transition, triggered from tabs
}

#pragma mark - Public Methods
- (void)setSelectedIndex:(NSInteger)index completion:(dispatch_block_t)completion {
    if (_selectedViewController.index == index) {
        if (completion) {
            completion();
        }
        return;
    }
    UIPageViewControllerNavigationDirection direction = (index > _selectedViewController.index) ? UIPageViewControllerNavigationDirectionForward: UIPageViewControllerNavigationDirectionReverse;
    PredictionContentViewController *nextViewController = [self viewControllerByIndex:index];
    NSCAssert(nextViewController, @"ViewController must be allocated");
    if (!nextViewController) {
        if (completion) {
            completion();
        }
        return;
    }
    @weakify(self);
    [_pageViewController setViewControllers:@[nextViewController]
                                      direction:direction
                                       animated:YES
                                 completion:^(BOOL finished) {
                                     @strongify(self);
                                     self.selectedViewController = nextViewController;
                                     if (completion) {
                                         completion();
                                     }
                                 }];
}

- (void)updateHeight {
    _heightConstraint.constant = [_selectedViewController getHeight];
}

@end
