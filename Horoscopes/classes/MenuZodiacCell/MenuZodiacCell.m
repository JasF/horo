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

@implementation MenuZodiacCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSArray *colors=@[[UIColor greenColor], [UIColor yellowColor], [UIColor blackColor], [UIColor blueColor], [UIColor cyanColor]];
    int colorIndex = arc4random_uniform(5);
    self.backgroundColor = [[colors objectAtIndex:colorIndex] colorWithAlphaComponent:(arc4random_uniform(2))?(arc4random_uniform(2))?0.2 : 0.4 : (arc4random_uniform(2))?0.6 : 1.f];
}

#pragma mark - Public Methods
- (void)setImage:(UIImage *)image title:(NSString *)title {
    [_button setImage:image forState:UIControlStateNormal];
    [_button setTitle:title forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_button horo_centerVertically];
}

@end
