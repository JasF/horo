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

typedef NS_ENUM(NSInteger, RowTypes) {
    TopSpaceRow,
    HiRow,
    FacebookLoginRow,
    PickerRow,
    RowsCount
};

static CGFloat const kRowHeight = 100;
static CGFloat const kFacebookLoginCellHeight = 44.f;

@interface WelcomeViewController () <UITableViewDelegate, UITableViewDataSource, FBSDKLoginButtonDelegate>
@property (strong, nonatomic) IBOutlet UITableViewCell *topSpaceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *hiCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *facebookLoginCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *pickerCell;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FBSDKLoginButton *loginButton;
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
    
    _loginButton = [FBSDKLoginButton new];
    _loginButton.delegate = self;
    _loginButton.readPermissions = @[@"public_profile", @"user_birthday", @"email", @"user_friends"];
    [_facebookLoginCell.contentView addSubview:_loginButton];    
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = kRowHeight;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    
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
    [self.view insertSubview:blurEffectView belowSubview:self.tableView];
    
    _pickerView.datePickerMode = UIDatePickerModeDate;
    [_pickerView setValue:[UIColor whiteColor] forKey:@"textColor"];
    _pickerView.maximumDate = [NSDate date];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutFacebookLoginButton];
}

- (void)layoutFacebookLoginButton {
    CGSize containerSize = CGSizeMake(self.view.width, kFacebookLoginCellHeight);
    CGRect frame = _loginButton.frame;
    frame.origin = CGPointMake(containerSize.width/2-frame.size.width/2, containerSize.height/2-frame.size.height/2);
    _loginButton.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == FacebookLoginRow) {
        return kFacebookLoginCellHeight;
    }
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return RowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case TopSpaceRow: cell = self.topSpaceCell; break;
        case HiRow: cell = self.hiCell; break;
        case FacebookLoginRow: cell = self.facebookLoginCell; break;
        case PickerRow: cell = self.pickerCell; break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
