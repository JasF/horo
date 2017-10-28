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

@property (assign, nonatomic) strong<horo::NetworkingService> networkingService;
@end

@implementation ViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    LOG(LS_ERROR) << "!";
    _networkingService = horo::Managers::shared().networkingService();
    
    using namespace horo;
    Json::Value parameters;
    parameters["id"] = 12345;
    parameters["stroke"] = "hello";
    @weakify(self);
    _networkingService->beginRequest("byZodiac", parameters, [self_weak_](strong<HttpResponse> response, Json::Value value){
        @strongify(self);
        std::string content = value["content"].asString();
        LOG(LS_WARNING) << "response! content: " << content;
        self.networkingService = nullptr;
    }, [](error err) {
        
    });
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
