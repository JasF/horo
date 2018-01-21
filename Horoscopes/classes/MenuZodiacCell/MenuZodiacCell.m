//
//  MenuZodiacCell.m
//  Horoscopes
//
//  Created by Jasf on 20.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "MenuZodiacCell.h"

@interface MenuZodiacCell ()
@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation MenuZodiacCell {
    NSString *_originalZodiacName;
}

#pragma mark - Public Methods
- (void)setImage:(UIImage *)image zodiacName:(NSString *)zodiacName {
    _originalZodiacName = zodiacName;
    if (zodiacName.length) {
        zodiacName = [zodiacName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[zodiacName substringToIndex:1] capitalizedString]];
    }
    [_button setImage:image forState:UIControlStateNormal];
    [_button setTitle:zodiacName forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_button horo_centerVertically];
}

- (IBAction)buttonTapped:(id)sender {
    NSCAssert(_originalZodiacName, @"originalZodiacName must be setted");
    if (!_originalZodiacName) {
        return;
    }
    if (_tappedBlock) {
        _tappedBlock(_originalZodiacName);
    }
}

@end
