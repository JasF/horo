//
//  Logger.m
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "Logger.h"

@interface Logger ()
@property (strong, nonatomic) NSDateFormatter *format;
@property (strong, nonatomic) NSFileHandle *fileHandle;
@end

@implementation Logger

#pragma mark - Public Static Methods
+ (instancetype)shared {
    static Logger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [Logger new];
    });
    return sharedInstance;
}

#pragma mark - Initialization
- (id)init {
    if (self = [super init]) {
        _format = [[NSDateFormatter alloc] init];
        _format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [self initializeFileHandleWithSeeking];
    }
    return self;
}

- (void)log:(NSString *)format, ... {
    va_list ap;
    va_start(ap, format);
    [self log:format args:ap];
}

- (void)log:(NSString *)format args:(va_list)ap {
    NSString *message = [[NSString alloc] initWithFormat:format arguments:ap];
    message = [[NSString alloc] initWithFormat:@"[%@]: %@", [_format stringFromDate:[NSDate date]], message];
    [_fileHandle writeData:[[message stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [_fileHandle synchronizeFile];
}

- (void)llog:(NSString *)format {
    [self log:format];
}

- (NSString *)readAll {
    [_fileHandle closeFile];
    _fileHandle = nil;
    NSData *data = [NSData dataWithContentsOfFile:[self filePath]];
    [self deleteFile];
    [self initializeFileHandle];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"logs.log"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return filePath;
}

- (void)initializeFileHandleWithSeeking {
    [self initializeFileHandle];
    [_fileHandle truncateFileAtOffset:0];
    [_fileHandle seekToEndOfFile];
}

- (void)initializeFileHandle {
    NSString *filePath = [self filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath
                             contents:nil
                           attributes:nil];
    }
    _fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
}

- (void)deleteFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:[self filePath] error:&error];
}

@end
