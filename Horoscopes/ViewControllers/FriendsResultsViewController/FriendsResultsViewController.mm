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
@interface FriendsResultsViewController ()
@end

@implementation FriendsResultsViewController
#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    NSCParameterAssert(_didSelectPerson);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonObjc *person = [self personFromCellAtIndexPath:indexPath];
    NSCAssert(person, @"person cannot be nil");
    if (!person) {
        return;
    }
    _didSelectPerson(person);
}

@end
