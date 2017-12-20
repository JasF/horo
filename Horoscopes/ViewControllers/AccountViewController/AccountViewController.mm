//
//  AccountViewController.m
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "AccountViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

static CGFloat const kAvatarAlphaWithImage = 1.f;

@interface AccountViewController () <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *youBirthdayDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *facebookLoginContainerView;
@property (strong, nonatomic) UIImage *defaultImage;
@property (assign, nonatomic) CGFloat defaultAlpha;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    NSCParameterAssert(_viewModel);
    [super viewDidLoad];
    _defaultImage = _avatarImageView.image;
    _defaultAlpha = _avatarImageView.alpha;
    _loginButton = [FBSDKLoginButton new];
    _loginButton.delegate = self;
    _loginButton.readPermissions = @[@"public_profile", @"user_birthday", @"email", @"user_friends"];
    [_facebookLoginContainerView addSubview:_loginButton];
    
    _youBirthdayDateLabel.text = L(_youBirthdayDateLabel.text);
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    _datePicker.maximumDate = [NSDate date];
    [self updatePersonInfo];
    @weakify(self);
    _viewModel->personGatheredCallback_ = [self_weak_](bool success) {
        @strongify(self);
        [self updatePersonInfo];
    };
    self.navigationItem.title = L(@"account");
}

- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
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
    _viewModel->loggedInOnFacebook();
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    _viewModel->userLoggedOut();
    [self updatePersonInfo];
    NSLog(@"DidLogout");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutFacebookLoginButton];
}

- (void)layoutFacebookLoginButton {
    CGSize containerSize = _facebookLoginContainerView.size;
    CGRect frame = _loginButton.frame;
    frame.origin = CGPointMake(containerSize.width/2-frame.size.width/2, containerSize.height/2-frame.size.height/2);
    _loginButton.frame = frame;
}

#pragma mark - Private Methods
- (void)updatePersonInfo {
    @weakify(self);
    _viewModel->personRepresentation([self_weak_](std::string imageUrl, std::string name, horo::DateWrapper birthday) {
        @strongify(self);
        self.nameLabel.text = [NSString stringWithUTF8String:name.c_str()];
        if (imageUrl.size()) {
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:imageUrl.c_str()]]];
            self.avatarImageView.alpha = kAvatarAlphaWithImage;
        }
        else {
            self.avatarImageView.alpha = self.defaultAlpha;
            self.avatarImageView.image = self.defaultImage;
        }
        if (birthday.year() && birthday.month()) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:((birthday.year()) ? NSCalendarUnitYear : 0) |
                                                                NSCalendarUnitMonth |
                                                                NSCalendarUnitDay
                                                       fromDate:[NSDate date]];
            components.year = birthday.year();
            components.month = birthday.month();
            components.day = birthday.day();
            NSDate *date = [calendar dateFromComponents:components];
            NSCAssert(date, @"date missing");
            if (!date) {
                return;
            }
            self.datePicker.date = date;
        }
    });
}

#pragma mark - Observers
- (IBAction)datePickerValueChanged:(id)sender {
    NSDate *date = self.datePicker.date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay |
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitYear
                                               fromDate:date];
    horo::DateWrapper birthdayDate((int)components.day,
                                   (int)components.month,
                                   (int)components.year);
    _viewModel->birthdayDateChanged(birthdayDate);
}
@end
