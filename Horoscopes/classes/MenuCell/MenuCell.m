//
//  MenuCell.m
//  Horoscopes
//
//  Created by Jasf on 03.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//
#import "MenuCell.h"
#import "DesignLabel.h"

@interface MenuCell ()
@property (strong, nonatomic) IBOutlet DesignLabel *label;
@property (assign, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITouch *activeTouch;
@end

@implementation MenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _descriptionLabel.text = L(_descriptionLabel.text);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_label animateHighligh:NO];
}

- (void)prepareForShowing {
    [_label animateHighligh:NO];
}

#pragma mark - Observers
- (IBAction)tapped:(id)sender {
    if (_tappedBlock) {
        if (_tappedBlock()) {
            _activeTouch = nil;
            return;
        }
    }
    [self executeCallback:TouchFinished];
}

- (void)touchBegin {
    [self executeCallback:TouchBegin];
}

- (void)touchCancelled {
    [self executeCallback:TouchCancelled];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self touchBegin];
    _activeTouch = touch;
    return YES;
}

#pragma mark - UIView Overriden Methods
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self cancelTouches:touches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self cancelTouches:touches];
}

- (void)cancelTouches:(NSSet<UITouch *> *)touches {
    if (!_activeTouch) {
        return;
    }
    if ([touches containsObject:_activeTouch]) {
        [self touchCancelled];
    }
}

#pragma mark - Private Methods
- (void)executeCallback:(TouchState)state {
    switch (state) {
        case TouchBegin: {
            [_label animateHighligh:YES];
            break;
        }
        case TouchCancelled: {
            [_label animateHighligh:NO];
            break;
        }
        case TouchFinished: {
            [_label animateHighligh:NO];
            break;
        }
    }
    if (state != TouchBegin) {
        _activeTouch = nil;
    }
}


@end
