//
//  ZodiacsCell.m
//  Horoscopes
//
//  Created by Jasf on 20.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "MenuZodiacCell.h"
#import "ZodiacsCell.h"

static NSString * const kZodiacCellNibName = @"kZodiacCellNibName";

@interface ZodiacsCell ()
@property (strong, nonatomic) NSArray *items;
@end

@implementation ZodiacsCell {
    ZodiacsLayoutController *_zodiacsLayoutController;
}

#pragma mark - Public Methods
- (void)setItems:(NSArray *)items {
    _items = items;
    NSCAssert(items.count == 12, @"incorrect number of items");
    NSCParameterAssert(_zodiacsLayoutController);
    [_zodiacsLayoutController setItems:items];
}

#pragma mark - Accessors
- (void)setZodiacsLayoutController:(ZodiacsLayoutController *)zodiacsLayoutController {
    _zodiacsLayoutController = zodiacsLayoutController;
    [self.contentView horo_addFillingSubview:_zodiacsLayoutController.view];
    [self setNeedsLayout];
}

@end
