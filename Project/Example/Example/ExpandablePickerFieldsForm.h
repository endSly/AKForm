//
//  ExpandablePickerFieldsForm.h
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AKForm.h>

@interface ExpandablePickerFieldsForm : AKFormController

@end

@interface ExpandablePickerFieldsFormContainer : UIViewController
@property(nonatomic, strong) IBOutlet UISlider *slider;
@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)sliderValueDidChange:(id)sender;
- (IBAction)segmentedControlDidChangeSelectedSegmentIndex:(id)sender;
@end
