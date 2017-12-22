//
//  FeedbackManager.m
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "FeedbackManager.h"

@interface FeedbackManager () <MFMailComposeViewControllerDelegate>
@end

@implementation FeedbackManager
#pragma mark - Public Static Methods
+ (instancetype)shared {
    static FeedbackManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FeedbackManager new];
    });
    return sharedInstance;
}

#pragma mark - Public Methods
- (void)showFeedbackController:(UIViewController *)parentViewController {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [self createFeedbackMailController];
        if (controller) {
            [parentViewController presentViewController:controller animated:YES completion:nil];
        }
    }
    else {
        NSString *path = [NSString
                          stringWithFormat:@"/&subject=%@&body=%@", L(@"lucky_horoscope_feedback"), [self getDefaultFeedbackTextBody]];
        NSURL *mailUrl = [[NSURL alloc] initWithScheme:@"mailto" host:@"luckyhoroscopes@gmail.com?" path:path];
        [[UIApplication sharedApplication] openURL:mailUrl];
    }
    return;
}

#pragma mark -
- (MFMailComposeViewController *)createFeedbackMailController {
    NSString *str = [self getDefaultFeedbackTextBody];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    if (!controller) {
        return nil;
    }
    [controller setMailComposeDelegate:self];
    [controller setToRecipients:[NSArray arrayWithObject:@"luckyhoroscopes@gmail.com"]];
    [controller setSubject:L(@"lucky_horoscope_feedback")];
    [controller setMessageBody:str isHTML:NO];
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    return controller;
}

- (NSString *)getDefaultFeedbackTextBody {
    NSString *token = @"";//[MRHManagers shared].remoteNotificationsService.token;
    NSString *uid = @"";//[MRHManagers shared].remoteNotificationsService.uid;
    if (token.length == 0) {
        token = @"";
    }
    if (uid.length == 0) {
        uid = @"";
    }
    NSString *formatString = L(@"feedback_text");
    formatString = [formatString stringByReplacingOccurrencesOfString:@"$^" withString:@"%@"];
    NSMutableString *result = [[NSString stringWithFormat:formatString, [UIDevice horo_systemVersion], token] mutableCopy];
    return result;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error {
    
}

@end
