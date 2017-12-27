//
//  PushTimeViewController.m
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "PushTimeViewController.h"

@interface PushTimeViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation PushTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return 23;
}

#pragma mark - UIPickerViewDelegate
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView
                      attributedTitleForRow:(NSInteger)row
                               forComponent:(NSInteger)component {
    NSString *string = [NSString stringWithFormat:@"%@:00", @(row)];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    return attributedString;
}

@end
