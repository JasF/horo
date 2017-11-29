//
//  TabsItemView.m
//  Horoscopes
//
//  Created by Jasf on 29.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "TabsItemView.h"
#import "UIView+TKGeometry.h"

@interface TabsItemView ()
@property IBOutlet UILabel *label;
@end

@implementation TabsItemView

- (void)updateSize {
    [_label sizeToFit];
    self.width = _label.width;
    self.height = self.superview.height;    
}

- (void)setTitle:(NSString *)title {
    _label.text = title;
}

@end
