//
//  FeedbackManager.m
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#include "managers/managers.h"
#import "FeedbackManager.h"

@interface FeedbackManager () <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) UIViewController *parentViewController;
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
            _parentViewController = parentViewController;
            [_parentViewController presentViewController:controller animated:YES completion:nil];
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
    NSCParameterAssert(horo::Managers::shared().notifications().get());
    NSString *token = [NSString stringWithUTF8String:horo::Managers::shared().notifications()->deviceToken().c_str()];
    NSString *formatString = L(@"feedback_text");
    formatString = [formatString stringByReplacingOccurrencesOfString:@"$^" withString:@"%@"];
    NSMutableString *result = [[NSString stringWithFormat:formatString, [UIDevice horo_systemVersion], token] mutableCopy];
    return result;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error {
    @weakify(self);
    [controller dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if (result == MFMailComposeResultSent && self.parentViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:L(@"send_feedback_thanks") message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self.parentViewController presentViewController:alert animated:YES completion:nil];
        }
        self.parentViewController = nil;
    }];
}

@end
