//
//  CSFormCellPickerView.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 8/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFormCell.h"
#import "CSMetadataCollection.h"

#define CELL_IDENTIFIER_PICKER @"pickerCell"

@class CSFormCellPickerView;

@protocol CSFormCellPickerViewDelegate <CSFormCellDelegate>
- (void)didChangeValueForPickerViewCell:(CSFormCellPickerView *)cell;
@end

@interface CSFormCellPickerView : CSFormCell <UIPickerViewDataSource, UIPickerViewDelegate>

///---------------------------------------------------------------------------------------
/// @name Cell Elements
///---------------------------------------------------------------------------------------

@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, weak) id<CSFormCellPickerViewDelegate> delegate;
@property(nonatomic, weak) CSMetadataCollection *metadataCollection;

@end
