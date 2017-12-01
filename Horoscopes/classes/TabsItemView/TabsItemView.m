//
//  TabsItemView.m
//  Horoscopes
//
//  Created by Jasf on 29.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "TabsItemView.h"
#import "UIView+TKGeometry.h"

static CGFloat const kHighlightedItemViewAlpha = 0.8f;
static CGFloat const kSemiHighlightedItemViewAlpha = kHighlightedItemViewAlpha / 2;

@interface TabsItemView () <UIGestureRecognizerDelegate>
@property IBOutlet UILabel *labelFirst;
@property IBOutlet UILabel *labelSecond;
@property (strong, nonatomic) UITouch *activeTouch;
@end

@implementation TabsItemView

#pragma mark - Public Methods
- (void)setTitle:(NSString *)title {
    _labelFirst.text = title;
    _labelSecond.text = title;
}

#pragma mark - Observers
- (IBAction)tapped:(id)sender {
    [self executeCallback:TabItemViewTouchFinished];
}

- (void)touchBegin {
    [self executeCallback:TabItemViewTouchBegin];
}

- (void)touchCancelled {
    [self executeCallback:TabItemViewTouchCancelled];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self touchBegin];
    _activeTouch = touch;
    return YES;
}

#pragma mark - UIView Overriden Methods
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_activeTouch) {
        return;
    }
    if ([touches containsObject:_activeTouch]) {
        [self touchCancelled];
    }
    NSLog(@"");
}

#pragma mark - Private Methods
- (void)executeCallback:(TabItemViewTouchState)state {
    NSCAssert(_touchesBlock, @"Block must be non nil");
    if (_touchesBlock) {
        _touchesBlock(state);
    }
    if (state != TabItemViewTouchBegin) {
        _activeTouch = nil;
    }
}

- (UILabel *)visibleLabel {
    return (IsEqualFloat(_labelFirst.alpha, 0.f)) ? _labelSecond : _labelFirst;
}

- (UILabel *)invisibleLabel {
    return ([self.visibleLabel isEqual:_labelFirst]) ? _labelSecond : _labelFirst;
}

- (void)setItemHighlighted:(BOOL)highlighted {
    [self setItemHighlighted:highlighted syncLabelColor:NO];
}

- (void)setItemHighlighted:(BOOL)highlighted syncLabelColor:(BOOL)syncLabelColor {
    UIColor *backgroundColor = (highlighted) ? [[UIColor whiteColor] colorWithAlphaComponent:kHighlightedItemViewAlpha] : [UIColor clearColor];
    if ([self.backgroundColor isEqual:backgroundColor]) {
        return;
    }
    self.backgroundColor = backgroundColor;
    UIColor *(^colorBlock)(BOOL aHighlighted) = ^UIColor *(BOOL aHighlighted) {
        return (aHighlighted) ? [UIColor blackColor] : [UIColor whiteColor];
    };
    
    UILabel *invisibleLabel = [self invisibleLabel];
    UILabel *visibleLabel = [self visibleLabel];
    
    
    invisibleLabel.textColor = colorBlock(highlighted);
    if (!syncLabelColor) {
        visibleLabel.textColor = colorBlock(highlighted);
    }
    
    invisibleLabel.alpha = 1.f;
    visibleLabel.alpha = 0.f;
}

- (void)setItemSemiHighlighted {
    UIColor *backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:kSemiHighlightedItemViewAlpha];
    if ([self.backgroundColor isEqual:backgroundColor]) {
        return;
    }
    self.backgroundColor = backgroundColor;
    UIColor *color = [UIColor grayColor];
    
    UILabel *invisibleLabel = [self invisibleLabel];
    UILabel *visibleLabel = [self visibleLabel];
    
    invisibleLabel.textColor = color;
    visibleLabel.textColor = color;
    
    invisibleLabel.alpha = 1.f;
    visibleLabel.alpha = 0.f;
}

- (void)setOverSelection {
    self.backgroundColor = [UIColor whiteColor];
}

@end
