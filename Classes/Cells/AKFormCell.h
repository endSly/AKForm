//
//  AKFormCell.h
//  
//
//  Created by Ahmed Khalaf on 3/11/2013.
//
//

#import <UIKit/UIKit.h>
#import "AKFormValue.h"

#define DEFAULT_FONT_TITLE              [UIFont boldSystemFontOfSize:17]
#define DEFAULT_FONT_VALUE              [UIFont systemFontOfSize:17]
#define DEFAULT_TEXTCOLOR_TITLE         [UIColor blackColor]
#define DEFAULT_TEXTCOLOR_VALUE         [UIColor blackColor]

#define DEFAULT_TITLE_WIDTH             100.f
#define MINIMUM_TITLE_WIDTH             50.f
#define MINIMUM_VALUE_WIDTH             50.f

#define PADDING_HORIZONTAL              15.f
#define PADDING_VERTICAL                5.f

@protocol AKFormCellValueDelegate <NSObject>
- (void)didInputValue:(AKFormValue *)value;
- (void)didSelectMetadata:(AKFormMetadata *)metadata inComponent:(NSUInteger)component inCollection:(AKFormMetadataCollection *)collection;
- (AKFormValue *)inputValue;
@end

@protocol AKFormCellDelegate <NSObject>
@end


@interface AKFormCell : UITableViewCell

@property(nonatomic, weak) id<AKFormCellValueDelegate> valueDelegate;

///---------------------------------------------------------------------------------------
/// @name Determining the available frame for content
///---------------------------------------------------------------------------------------

/**
 *  This method deteremines the frame in which content can be placed, by padding the 
 *  cell's contentView by the specified amounts. If an accessory is present, then the
 *  right padding is ignored, as the contentView is already padded on that side.
 *
 *  @return The frame in which elements should be placed within this cell, or CGRectZero 
 *          if the available space is not enough to be padded with the constant padding 
 *          values.
 */
- (CGRect)contentFrame;

- (void)invalidate;

@end
