//
//  HTTPSessionManager.m
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "HTTPSessionManager.h"

static NSString * const HTTPSessionManagerAPIBaseURLString = @"http://127.0.0.1:8002/";

@implementation HTTPSessionManager

+ (instancetype)sharedClient {
    static HTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HTTPSessionManagerAPIBaseURLString]];
    });
    return _sharedClient;
}

@end

