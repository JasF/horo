//
//  FriendsBaseViewController.m
//  Horoscopes
//
//  Created by Jasf on 12.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FriendsBaseViewController.h"
#import "FriendsCell.h"

static NSString *const kCellIdentifier = @"cellID";
static NSString *const kTableCellNibName = @"FriendsCell";

static CGFloat const kEstimatedRowHeight = 50.f;

@implementation FriendsBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = kEstimatedRowHeight;
    self.tableView.separatorColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil] forCellReuseIdentifier:kCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)reloadCellWithPerson:(PersonObjc *)person {
    FriendsCell *neededCell = nil;
    for (FriendsCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[FriendsCell class]] && [cell.datasource isEqual:person]) {
            neededCell = cell;
            break;
        }
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:neededCell];
    if (indexPath) {
        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return;
    }
    [self.tableView reloadData];
}

- (PersonObjc *)personFromCellAtIndexPath:(NSIndexPath *)indexPath {
    FriendsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSCAssert([cell isKindOfClass:[FriendsCell class]], @"cell is not friends cell");
    NSCAssert([cell.datasource isKindOfClass:[PersonObjc class]], @"datasource is not PrsonObjc");
    if (!cell || ![cell.datasource isKindOfClass:[PersonObjc class]]) {
        return nil;
    }
    PersonObjc *person = (PersonObjc *)cell.datasource;
    return person;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_friendsSection == section) {
        return _friends.count;
    }
    NSCAssert(_friendsSection != section, @"Unhandled section: %@", @(section));
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    NSCAssert(index < _friends.count, @"index out of bounds");
    if (index >= _friends.count) {
        return [UITableViewCell new];
    }
    
    PersonObjc *person = _friends[index];
    NSString *zodiacName = person.zodiac.name;
    FriendsCell *cell = (FriendsCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell setName:person.name
         birthday:person.birthdayString
         imageUrl:person.imageUrl
       zodiacName:zodiacName];
    [cell setActivityIndicatorAnimationEnabled:person.updating];
    cell.datasource = person;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

@end
