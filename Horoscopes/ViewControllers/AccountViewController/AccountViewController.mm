//
//  AccountViewController.m
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    NSCParameterAssert(_viewModel);
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
