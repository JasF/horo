//
//  MenuSimpleCell.m
//  Horoscopes
//
//  Created by Jasf on 16.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "MenuSimpleCell.h"

@interface MenuSimpleCell ()
@property (strong, nonatomic) IBOutlet UILabel *label;
@end

@implementation MenuSimpleCell

- (void)setText:(NSString *)text {
    _label.text = text;
}

@end
