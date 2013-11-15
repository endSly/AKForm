//
//  AKFormCell.m
//  
//
//  Created by Ahmed Khalaf on 3/11/2013.
//
//

#import "AKFormCell.h"

@implementation AKFormCell

- (CGRect)contentFrame
{
    //first get the available frame
    CGRect f = self.contentView.frame;
    
    //now pad the width
    CGFloat width = f.size.width - (PADDING_HORIZONTAL * 2.0);
    
    //if needed, add some more padding for the accessory
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        width += PADDING_HORIZONTAL;
    }
    
    //pad the height
    CGFloat height = f.size.height - (PADDING_VERTICAL * 2.0);
    
    //make sure the width and height aren't negative
    if (width <= 0 || height <= 0) {
        return CGRectZero;
    } else {
        //row return a centered, padded frame
        return CGRectMake(f.origin.x + PADDING_HORIZONTAL,
                          f.origin.y + PADDING_VERTICAL,
                          width, height);
    }
}

- (void)invalidate
{    
}
@end
