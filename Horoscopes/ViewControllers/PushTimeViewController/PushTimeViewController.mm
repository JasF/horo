//
//  PushTimeViewController.m
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "PushTimeViewController.h"

static NSInteger const kNumberOfComponents = 1;
static NSInteger const kNumberOfRowsInComponents = 24;

@interface PushTimeViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation PushTimeViewController

- (void)viewDidLoad {
    NSCParameterAssert(_viewModel.get());
    [super viewDidLoad];
    self.navigationItem.title = L(@"push_time_title");
    int pushTime = _viewModel->pushTime();
    NSCAssert(pushTime < kNumberOfRowsInComponents, @"pushTime out of bounds");
    if (pushTime >= kNumberOfRowsInComponents) {
        return;
    }
    [_pickerView selectRow:pushTime inComponent:0 animated:NO];
    [self.navigationController.navigationBar horo_makeWhite];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return kNumberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return kNumberOfRowsInComponents;
}

#pragma mark - UIPickerViewDelegate
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView
                      attributedTitleForRow:(NSInteger)row
                               forComponent:(NSInteger)component {
    NSString *string = [NSString stringWithFormat:@"%@:00", @(row)];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    return attributedString;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    _viewModel->setPushTime((int)row);
}

@end
