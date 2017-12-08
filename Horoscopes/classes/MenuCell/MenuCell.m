//
//  MenuCell.m
//  Horoscopes
//
//  Created by Jasf on 07.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "MenuCellContentView.h"
#import "MenuCell.h"

@interface MenuCell ()
@property (strong, nonatomic) IBOutlet MenuCellContentView *containerView;
@end

@implementation MenuCell

#pragma mark - Accessors
- (void)setTappedBlock:(TappedBlock)tappedBlock {
    _containerView.tappedBlock = tappedBlock;
}

- (TappedBlock)tappedBlock {
    return _containerView.tappedBlock;
}

@end
