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

#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseFirestore/FirebaseFirestore.h>

@interface WelcomeViewController () <UITableViewDelegate, UITableViewDataSource, FBSDKLoginButtonDelegate>
@property (strong, nonatomic) IBOutlet UITableViewCell *facebookLoginCell;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property (strong, nonatomic) FIRFirestore *db;
@property (strong, nonatomic) FIRCollectionReference *collRef;
@property (strong, nonatomic) FIRDocumentReference *docRef;

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
    
    _db = [FIRFirestore firestoreForApp:[FIRApp defaultApp]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _collRef = [self.db collectionWithPath:@"horoscopes"];
        _docRef = [_collRef documentWithPath:@"capricorn"];
        [_docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
            if (snapshot != nil) {
                NSLog(@"Document data: %@", snapshot.data);
                NSArray *result = snapshot.data[@"result"];
                if ([result isKindOfClass:[NSArray class]]) {
                    NSLog(@"Allright! %@", result);
                }
            } else {
                NSLog(@"Document does not exist");
            }
        }];
    });
    
    _loginButton.delegate = self;
    _loginButton.readPermissions = @[@"public_profile", @"user_birthday", @"email", @"user_friends"];
    @weakify(self);
    _viewModel->userLoggedInCallback_ = [self_weak_](bool success){
        @strongify(self);
        LOG(LS_WARNING) << "User gathered! success: " << success;
        [self hideProgressHud];
    };
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: return self.facebookLoginCell;
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


/**
 Sent to the delegate when the button was used to logout.
 - Parameter loginButton: The button that was clicked.
 */
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"DidLogout");
}

#pragma mark - Private Methods
- (void)hideProgressHud {
    
}

- (void)showProgressHud {
    
}

@end
