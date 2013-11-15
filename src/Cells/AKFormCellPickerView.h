//
//  AKFormCellPickerView.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 8/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKFormCell.h"
#import "AKFormMetadataCollection.h"

#define CELL_IDENTIFIER_PICKER @"pickerCell"

@class AKFormCellPickerView;

@protocol CSFormCellPickerViewDelegate <CSFormCellDelegate>
- (void)didChangeValueForPickerViewCell:(AKFormCellPickerView *)cell;
@end

@interface AKFormCellPickerView : AKFormCell <UIPickerViewDataSource, UIPickerViewDelegate>

///---------------------------------------------------------------------------------------
/// @name Cell Elements
///---------------------------------------------------------------------------------------

@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, weak) id<CSFormCellPickerViewDelegate> delegate;
@property(nonatomic, weak) AKFormMetadataCollection *metadataCollection;

@end
