//
//  WelcomeViewController.m
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "WelcomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#include "UIView+TKGeometry.h"
#include "data/datewrapper.h"
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseFirestore/FirebaseFirestore.h>

static CGFloat const kRowHeight = 100;

@interface WelcomeViewController () <UITableViewDelegate, UITableViewDataSource, FBSDKLoginButtonDelegate>
@property (strong, nonatomic) IBOutlet UITableViewCell *topSpaceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *hiCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *facebookLoginCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *pickerCell;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (strong, nonatomic) id selfLocker;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@end

@implementation WelcomeViewController

#pragma mark - Setters
- (void)setViewModel:(strong<horo::HelloScreenViewModel>)viewModel {
    _viewModel = viewModel;
    if (_viewModel) {
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSCParameterAssert(_viewModel);
    
    //_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // 20 or 64pt on top
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = kRowHeight;
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.separatorColor = [UIColor clearColor];
    
    _loginButton.delegate = self;
    _loginButton.readPermissions = @[@"public_profile", @"user_birthday", @"email", @"user_friends"];
    @weakify(self);
    _viewModel->setUserLoggedInCallback([self_weak_](bool success){
        @strongify(self);
        LOG(LS_WARNING) << "User gathered! success: " << success;
        [self hideProgressHud];
        [self hideWindow];
    });
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.view.bounds];
    [self.view insertSubview:blurEffectView belowSubview:_tableView];
    
    _pickerView.datePickerMode = UIDatePickerModeDate;
    [_pickerView setValue:[UIColor whiteColor] forKey:@"textColor"];
    _pickerView.maximumDate = [NSDate date];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: return self.topSpaceCell;
        case 1: return self.hiCell;
        case 2: return self.facebookLoginCell;
        case 3: return self.pickerCell;
    }
    return [UITableViewCell new];
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if (result.isCancelled) {
        return;
    }
    NSCAssert(result.grantedPermissions.count, @"Granted permissions is empty. We are authorized?");
    if (!result.grantedPermissions.count || error) {
        return;
    }
    _viewModel->loggedInOverFacebook();
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"DidLogout");
}

#pragma mark - Private Methods
- (void)hideProgressHud {
    
}

- (void)showProgressHud {
    
}

- (IBAction)testTapped:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.size.width, 200);
        [self.navigationController.navigationBar layoutIfNeeded];
    });
}

- (void)lockSelf {
    self.selfLocker = self;
}

#pragma mark - Observers
- (IBAction)continueTapped:(id)sender {
    NSDate *date = _pickerView.date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay |
    NSCalendarUnitMonth |
    NSCalendarUnitYear
                fromDate:date];
    horo::DateWrapper wrapper((int)components.day,
                              (int)components.month,
                              (int)components.year);
    _viewModel->continueTapped(wrapper);
}

- (void)hideWindow {
    @weakify(self);
    [UIView animateWithDuration:0.5f animations:^{
        self.view.alpha = 0.f;
    }
                     completion:^(BOOL finished) {
                         @strongify(self);
                         self.selfLocker = nil;
                     }
     ];
}

@end
