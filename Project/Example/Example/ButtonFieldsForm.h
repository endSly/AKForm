//
//  ButtonFieldsForm.h
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AKForm.h>

@interface ButtonFieldsForm : AKFormController

@end

@interface ButtonFieldsFormContainer : UIViewController
@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlDidChangeSelectedSegmentIndex:(id)sender;
@end
