//
//  GradientView.m
//  Horoscopes
//
//  Created by Jasf on 13.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UIImageView+Horo.h"
#import "GradientView.h"

@interface GradientView ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation GradientView

- (void)layoutSubviews {
    CGSize size = self.size;
    if (!CGSizeEqualToSize(_imageView.image.size, size)) {
        _imageView.image = [UIImageView horo_generateWithSize:size type:GradientGradientView];
    }
}

@end
