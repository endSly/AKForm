//
//  CSFormTextViewCell.h
//  AKForm
//
//  Created by Ahmed Khalaf on 16/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormBaseCell.h"

#define CELL_IDENTIFIER_TEXTVIEW        @"textViewCell"

/**
 *  A type of cell that presents a text view for writing a large chunk of text in.
 */
@interface CSFormTextViewCell : CSFormBaseCell

///---------------------------------------------------------------------------------------
/// @name Cell Elements
///---------------------------------------------------------------------------------------

/**
 *  The text view on the cell
 */
@property(nonatomic, strong) UITextView *textView;

///---------------------------------------------------------------------------------------
/// @name Text View
///---------------------------------------------------------------------------------------

/**
 *  The height for the text view
 */
@property(nonatomic, assign) CGFloat textViewHeight;

@end
