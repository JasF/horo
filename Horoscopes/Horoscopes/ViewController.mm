//
//  ViewController.m
//  Horoscopes
//
//  Created by ANDREI VAYAVODA on 25.10.17.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "ViewController.h"
#import "rtc_base/logging.h"
#import "managers/managers.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LOG(LS_ERROR) << "!";
    horo::NetworkingService *networkingService = horo::Managers::shared().networkingService();
    networkingService->beginRequest("http://127.0.0.1:8000", [](Json::Value value){
        std::string content = value["content"].asString();
        LOG(LS_WARNING) << "response! content: " << content;
    });
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
