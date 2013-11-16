//
//  CSFormBaseCell.m
//  AKForm
//
//  Created by Ahmed Khalaf on 11/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormBaseCell.h"

#define LABEL_FONT              [UIFont systemFontOfSize:17]
#define LABEL_LINE_BREAK_MODE   NSLineBreakByTruncatingTail

@interface CSFormBaseCell()
@property(nonatomic, strong) NSString *labelString;
@end

@implementation CSFormBaseCell

#pragma mark - Initializers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftViewSize = CGSizeZero;
    }
    return self;
}

#pragma mark - Cell Label

- (void)setLabelString:(NSString *)labelString
{
    _labelString = labelString;
}

- (BOOL)hasLabelString
{
    return (self.labelString && self.labelString.length > 0);
}

#pragma mark - Subview Frames

- (void)layoutSubviews
{
    [super layoutSubviews];
}

//lays out the cell with the supplied left and right view
- (void)layoutWithLeftView:(UIView *)leftView rightView:(UIView *)rightView
{
    //special case for labels, fit the frame tightly snug around it first
}

//lays out the cell with a single view
- (void)layoutWithView:(UIView *)view
{
    
}

//helper that sets the left element size based on a supplied height only
// (assuming we want the entire available width)
- (void)setLeftViewHeight:(CGFloat)leftElementHeight
{
    CGRect contentFrame = [self contentFrame];
    CGSize elementSize = CGSizeMake(contentFrame.size.width, leftElementHeight);
    [self setLeftViewSize:elementSize];
}

// sets the left element size, making sure it is confined within the content frames bounds though!
- (void)setLeftViewSize:(CGSize)leftViewSize
{
    CGRect contentFrame = [self contentFrame];
    CGFloat width = (leftViewSize.width > contentFrame.size.width ?
                     contentFrame.size.width : leftViewSize.width);
    self.leftViewSize = CGSizeMake(width, leftViewSize.height);
}

- (CGRect)leftViewFrame
{
    return CGRectMake([self contentFrame].origin.x, [self contentFrame].origin.y,
                      self.leftViewSize.width, self.leftViewSize.height);
}

//- (CGRect)updateFrameForLeftLabel
//{
//    CGSize labelSize = [self sizeForLabel];
//    [self setLeftViewSize:labelSize];
//    return [self leftViewFrame];
//}

- (CGRect)rightViewFrame
{
    CGRect contentFrame = [self contentFrame];
    
    if (CGRectIsEmpty(self.leftViewFrame)) {
        return contentFrame;
    } else {
        CGFloat labelWidthWithPadding = self.leftViewFrame.size.width + CELL_PADDING_HORIZONTAL;
        
        return CGRectMake(labelWidthWithPadding + CELL_PADDING_HORIZONTAL,
                          contentFrame.origin.y,
                          contentFrame.size.width - labelWidthWithPadding,
                          contentFrame.size.height);
    }
}

#pragma mark - Private helpers

/**
 *  Calculates frame in which content should be placed, by padding the cell's
 *  contentView by the specified amounts. If an accessory is present, then the
 *  right padding is ignored, as the contentView is already padded on that side.
 *
 *  @return The frame in which elements should be placed within this cell
 */
- (CGRect)contentFrame
{
    CGRect f = self.contentView.frame;
    CGFloat width = f.size.width - (CELL_PADDING_HORIZONTAL * 2.0);
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        width += CELL_PADDING_HORIZONTAL;
    }
    
    return CGRectMake(f.origin.x + CELL_PADDING_HORIZONTAL,
                      f.origin.y + CELL_PADDING_VERTICAL,
                      width,
                      f.size.height - (CELL_PADDING_VERTICAL * 2.0));
}

/**
 *  This method returns the size needed for the label string.
 *
 *  @return The `CGSize` needed for the `labelString`, or `CGSizeZero` if none is provided
 */
- (CGSize)sizeForLabel
{
    CGRect contentFrame = [self contentFrame];
    if ([self hasLabelString]) {
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        attributes[NSFontAttributeName] = LABEL_FONT;
        CGRect labelRect = [self.labelString boundingRectWithSize:contentFrame.size
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:attributes
                                                          context:nil];
        return CGSizeMake(labelRect.size.width,
                          contentFrame.size.height);
    } else {
        return CGSizeZero;
    }
}

@end
