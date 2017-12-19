//
//  BaseNavigationController.m
//  Horoscopes
//
//  Created by Jasf on 26.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BackgroundView.h"
#import "UIView+Horo.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    BackgroundView *backgroundView = [BackgroundView new];
    [self.view horo_addFillingSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    self.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
