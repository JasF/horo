//
//  FriendsResultsViewController.m
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "horobase.h"
#import "FriendsResultsViewController.h"
#import "FriendsCell.h"

using namespace std;

static CGFloat const kEstimatedRowHeight = 50.f;
NSString *const kCellIdentifier = @"cellID";
NSString *const kTableCellNibName = @"FriendsCell";

@interface FriendsResultsViewController ()
@end

@implementation FriendsResultsViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = kEstimatedRowHeight;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filteredFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSCAssert(indexPath.row < _filteredFriends.count, @"index out of bounds");
    if (indexPath.row >= _filteredFriends.count) {
        return [UITableViewCell new];
    }
    
    FriendsCell *cell = (FriendsCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    PersonObjc *person = _filteredFriends[indexPath.row];
    [cell setName:person.name birthday:person.birthday];
    return cell;
}

@end
