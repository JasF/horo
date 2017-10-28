//
//  HTTPSessionManager.h
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface HTTPSessionManager : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
