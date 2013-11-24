//
//  AKFormFieldLabelled.h
//  
//
//  Created by Ahmed Khalaf on 24/11/2013.
//
//

#import "AKFormField.h"
#import "AKFormCellLabel.h"

@interface AKFormFieldLabelled : AKFormField

@property(nonatomic, weak) id<AKFormCellLabelStyleProvider> styleProvider;

- (AKFormCellLabel *)labelCell;

@end
