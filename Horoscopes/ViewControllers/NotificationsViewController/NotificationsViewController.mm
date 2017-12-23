//
//  NotificationsViewController.m
//  Horoscopes
//
//  Created by Jasf on 23.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    NSCParameterAssert(_viewModel.get());
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuTapped:(id)sender {
    _viewModel->menuTapped();
}

@end
