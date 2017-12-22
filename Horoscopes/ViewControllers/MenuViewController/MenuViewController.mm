//
//  MenuViewController.m
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"

typedef NS_ENUM(NSInteger, MenuRows) {
    CloseRow,
    FriendsRow,
    AccountRow,
    NotifcationsRow,
    FeedbackRow,
    RowsCount
};

static CGFloat const kRowHeight = 100;

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *closeCell;
@property (strong, nonatomic) IBOutlet MenuCell *friendsCell;
@property (strong, nonatomic) IBOutlet MenuCell *accountCell;
@property (strong, nonatomic) IBOutlet MenuCell *notificationsCell;
@property (strong, nonatomic) IBOutlet MenuCell *feedbackCell;
@property (weak, nonatomic) IBOutlet UILabel *friendsDescriptionLabel;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSCParameterAssert(_viewModel);
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = kRowHeight;
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.allowsSelection = NO;
    _friendsDescriptionLabel.text = L(@"begin_update");
    @weakify(self);
    _friendsCell.tappedBlock = ^BOOL{
        @strongify(self);
        self.viewModel->friendsTapped();
        return YES;
    };
    _accountCell.tappedBlock = ^BOOL{
        @strongify(self);
        self.viewModel->accountTapped();
        return YES;
    };
    _notificationsCell.tappedBlock = ^BOOL{
        @strongify(self);
        self.viewModel->notificationsTapped();
        return NO;
    };
    _feedbackCell.tappedBlock = ^BOOL{
        @strongify(self);
        self.viewModel->feedbackTapped();
        return NO;
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CloseRow: return self.closeCell;
        case FriendsRow: return self.friendsCell;
        case AccountRow: return self.accountCell;
        case NotifcationsRow: return self.notificationsCell;
        case FeedbackRow: return self.feedbackCell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(MenuCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[MenuCell class]]) {
       // [cell prepareForShowing];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return RowsCount;
}

#pragma mark - Observer
- (IBAction)friendsTapped:(id)sender {
    _viewModel->friendsTapped();
}

- (IBAction)zodiacsTapped:(id)sender {
    _viewModel->zodiacsTapped();
}
- (IBAction)closeTapped:(id)sender {
    _viewModel->closeTapped();
}

@end
