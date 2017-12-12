//
//  FriendsBaseViewController.m
//  Horoscopes
//
//  Created by Jasf on 12.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "FriendsBaseViewController.h"

static CGFloat const kEstimatedRowHeight = 50.f;

@interface FriendsBaseViewController ()

@end

@implementation FriendsBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = kEstimatedRowHeight;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
