//
//  CSForm.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 9/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSForm.h"
#import "CSFormBaseCell.h"
#import "CSFormFieldSwitch.h"

#import "CSFormValueValidator.h"

@interface CSForm ()
@property(nonatomic, strong) NSMutableArray *sections;
- (CSFormField *)fieldForIndexPath:(NSIndexPath *)indexPath;
@end

@implementation CSForm

#pragma mark - Initializers & Constructors

+ (instancetype)formWithSections:(NSArray *)sections
{
    return [[self alloc] initWithSections:sections];
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.sections = [NSMutableArray array];
    return self;
}

- (instancetype)initWithSections:(NSArray *)sections
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.sections = [NSMutableArray arrayWithArray:sections];
    return self;
}

#pragma mark - Convenience Helpers



// mention explicitly that content switching fields can only switch on off fields within their section, or other COMPLETE
// sections (ie. not specific fields in OTHER sections that have other fields too)
// THROWS exception if we have more than one switch with these actions on the same section? - why not though???!?!
- (void)addSection:(CSFormSection *)section
{
    //with context switcher
    CSFormSection *accompanyingSection;
    
    BOOL alreadyFoundOne = NO;
    
//commented out for now, we'll deal with this when we get to context togglers
//    for (CSFormField *field in section.fields) {
//        //only handles switches for now, we need to handle other toggles too, like segmented ones, and perhaps think of others?
//        if ([field isKindOfClass:[CSFormFieldSwitch class]]) {
//            CSFormFieldSwitch *switchField = (CSFormFieldSwitch *)field;
//            
//            if (switchField.fieldsToHideOnOn || switchField.fieldsToShowOnOn) {
//                if (alreadyFoundOne) {
//                    [NSException raise:@"More than 1 content switching field in section" format:@"Field with key %@ in section %@ is the second content switching field. Only 1 is permitted", switchField.key, section.key];
//                }
//                
//                //show the appropriate section
//                NSMapTable *mappedFields;
//                if ([switchField.value boolValue] && switchField.fieldsToShowOnOn) {
//                    mappedFields = switchField.fieldsToShowOnOn;
//                } else if (![switchField.value boolValue] && switchField.fieldsToHideOnOn) {
//                    mappedFields = switchField.fieldsToHideOnOn;
//                }
//                
//                NSArray *keys = [[mappedFields keyEnumerator] allObjects];
//                for (CSFormSection *s in keys) {
//                    NSArray *fields = [mappedFields objectForKey:s];
//                    if ([section isEqual:s]) {
//                        [section addFields:fields];
//                    } else {
//                        [s addFields:fields];
//                        accompanyingSection = s;
//                    }
//                }
//                
//                alreadyFoundOne = YES;
//            }
//        }
//    }

    //add it last in case we've added fields to it (due to switch)
    [self.sections addObject:section];
    
    if (accompanyingSection) {
        [self.sections addObject:accompanyingSection];
    }
}

- (NSInteger)removeSection:(CSFormSection *)section
{
    NSUInteger index = [self.sections indexOfObject:section];
    [self.sections removeObjectAtIndex:index];
    return index;
}

- (NSUInteger)insertSection:(CSFormSection *)section afterSection:(CSFormSection *)sectionToAddAfter
{
    NSUInteger index = [self.sections indexOfObject:sectionToAddAfter];
    if (index != NSNotFound) {
        index++;
        [self.sections insertObject:section atIndex:index];
    } else {
        [self addSection:section];
        index = [self.sections indexOfObject:section];
    }
    return index;
}

#pragma mark - Convenience Helpers

- (NSIndexPath *)indexPathForField:(CSFormField *)aField
{
    return [self.tableView indexPathForCell:aField.cell];
}

- (CSFormField *)fieldForIndexPath:(NSIndexPath *)indexPath
{
    if (self.sections && self.sections.count > indexPath.section) {
        CSFormSection *section = self.sections[indexPath.section];
        return [section fieldAtRowNumber:indexPath.row];
    }
    return nil;
}

- (CSFormFieldExpandable *)currentlyExpandedField
{
    for (CSFormSection *section in self.sections) {
        CSFormFieldExpandable *expandedField = [section expandedField];
        if (expandedField) {
            return expandedField;
        }
    }
    return nil;
}

- (NSIndexPath *)indexPathOfCurrentlyExpandedField
{
    CSFormFieldExpandable *expandedField = [self currentlyExpandedField];
    if (expandedField && expandedField.expandedCell) {
        return [self.tableView indexPathForCell:expandedField.cell];
    } else {
        return nil;
    }
}

- (CSFormField *)nextFieldToCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath && self.sections.count > indexPath.section) {
        CSFormSection *section = self.sections[indexPath.section];
        //if this isn't the last field in the section
        if (indexPath.row + 1 < [section numberOfFields] - 1) {
            return [section fieldAtIndex:indexPath.row + 1];
        } else {
            //if we have another section with at least one row
            if (indexPath.section + 1 < self.sections.count &&
                [self.sections[indexPath.section] numberOfFields] > 0) {
                return [self.sections[indexPath.section] fieldAtIndex:0];
            } else {
                //this is the last row
                //TODO, support cyclical prev/next stuff by returning the first field here
                return nil;
            }
        }
    }
    return nil;
}

- (NSIndexPath *)indexPathAfter:(NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
}

- (NSIndexPath *)indexPathBefore:(NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
}

#pragma mark - Collapsers / Expanders

- (NSIndexPath *)collapseCurrentlyExpandedField
{
    NSIndexPath *indexPath = [self indexPathOfCurrentlyExpandedField];
    
    if (indexPath) {
        //TODO, think of what useful thing we may do with this return value from collapseFieldAtRowNumber
        [self.sections[indexPath.section] collapseFieldAtRowNumber:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[[self indexPathAfter:indexPath]]
                              withRowAnimation:UITableViewRowAnimationFade];
        return indexPath;
    }
    return nil;
}

- (void)expandFieldAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: What if a field is already expanded? Don't assume it isn't!
    if (self.sections && self.sections.count > indexPath.section) {
        CSFormSection *section = self.sections[indexPath.section];
        
        //TODO: return a value from this and only do the following row
        // insertion and stuff if the section actually did confirm
        // the expansion. Don't assume it happened.
        [section expandFieldAtRowNumber:indexPath.row];
    }

    NSIndexPath *indexPathToInsert = [self indexPathAfter:indexPath];
    [self.tableView insertRowsAtIndexPaths:@[indexPathToInsert]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPathToInsert
                          atScrollPosition:UITableViewScrollPositionNone
                                  animated:YES];
}

- (BOOL)isIndexPathExpansion:(NSIndexPath *)indexPath
{
    CSFormField *field = [self fieldForIndexPath:indexPath];
    if (field) {
        if ([field isKindOfClass:[CSFormFieldExpandable class]] &&
            [(CSFormFieldExpandable *)field isExpanded]) {
            NSIndexPath *previousIndexPath = [self indexPathBefore:indexPath];
            if (previousIndexPath.row >= 0) {
                CSFormField *previousField = [self fieldForIndexPath:previousIndexPath];
                return [previousField isEqual:field];
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.sections && self.sections.count > section) {
        return [self.sections[section] headerTitle];
    } else {
        return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.sections && self.sections.count > section) {
        return [self.sections[section] footerTitle];
    } else {
        return @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.sections) {
        return self.sections.count;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sections && self.sections.count > section) {
        return [self.sections[section] numberOfRows];
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sections && self.sections.count > indexPath.section) {
        CSFormSection *section = self.sections[indexPath.section];
        [section tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sections && self.sections.count > indexPath.section) {
        CSFormSection *section = self.sections[indexPath.section];
        return [section tableView:tableView cellForRowAtRowNumber:indexPath.row];
    } else {
        return [[[CSFormField alloc] init] cellForTableView:tableView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSFormField *field = [self fieldForIndexPath:indexPath];
    if ([field isKindOfClass:[CSFormFieldText class]]) {
        CSFormFieldText *textField = (CSFormFieldText *)field;
        if (textField.styleProvider && [textField.styleProvider respondsToSelector:@selector(heightForTextFieldCell:)]) {
            return [textField.styleProvider heightForTextFieldCell:nil];
        }
    } else {
        if ([field isKindOfClass:[CSFormFieldExpandable class]]) {
            if ([(CSFormFieldExpandable *)field isExpanded]
                && [self isIndexPathExpansion:indexPath]) {
                return CELL_HEIGHT_PICKER;
            } else {
                //if this is the label cell
                CSFormFieldExpandable *expandableField = (CSFormFieldExpandable *)field;
                if (expandableField.styleProvider &&
                    [expandableField.styleProvider respondsToSelector:@selector(heightForLabelCell:)]) {
                    return [expandableField.styleProvider heightForLabelCell:nil];
                }
            }
        } else if ([field isKindOfClass:[CSFormFieldImage class]]) {
            CSFormFieldImage *imageField = (CSFormFieldImage *)field;
            if (imageField.styleProvider &&
                [imageField.styleProvider respondsToSelector:@selector(heightForImageCell:)]) {
                return [imageField.styleProvider heightForImageCell:nil];
            }
        } else if ([field isKindOfClass:[CSFormFieldTextView class]]) {
            return [(CSFormFieldTextView *)field textViewHeight] + (CELL_PADDING_VERTICAL * 2.0);
        }
    }
    return CELL_HEIGHT_DEFAULT;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewController.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CSFormField *field = [self fieldForIndexPath:indexPath];
    if ([field isKindOfClass:[CSFormFieldExpandable class]]) {
        //if a field is already expanded
        if ([self currentlyExpandedField]) {
            if ([indexPath isEqual:[self indexPathOfCurrentlyExpandedField]]) {
                [self collapseCurrentlyExpandedField];
            } else {
                NSIndexPath *collapsedIndexPath = [self collapseCurrentlyExpandedField];
                if (collapsedIndexPath) {
                    //if the collapsed index path was after the selected index path in the same section
                    if (indexPath.row > collapsedIndexPath.row && indexPath.section == collapsedIndexPath.section) {
                        indexPath = [self indexPathBefore:indexPath];
                    }
                    [self expandFieldAtIndexPath:indexPath];
                }
            }
        } else {
            [self expandFieldAtIndexPath:indexPath];
        }
    } else if ([field isKindOfClass:[CSFormFieldText class]]) {
    } else if ([field isKindOfClass:[CSFormFieldModalPicker class]]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"multipickerController"];
        [self.viewController.navigationController presentViewController:nc animated:YES completion:nil];
        
        UITableViewController *tvc = (UITableViewController *)nc.topViewController;
        CSFormFieldModalPicker *modalPickerField = (CSFormFieldModalPicker *)field;
        tvc.tableView.delegate = modalPickerField;
        tvc.tableView.dataSource = modalPickerField;
        
        tvc.navigationItem.title = modalPickerField.title;
    } else if ([field isKindOfClass:[CSFormFieldImage class]]) {
        CSFormFieldImage *imageField = (CSFormFieldImage *)field;
        [imageField select];
    }
}

#pragma mark - Prev/Next stuff

- (void)makeFirstResponder:(CSFormField *)aField
{
    [self.viewController.view endEditing:YES];
    
    NSIndexPath *indexPath = [self indexPathForField:aField];
    if (aField) {
        if ([aField isKindOfClass:[CSFormFieldText class]]) {
            UITableViewCell *cell;
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell isKindOfClass:[CSFormCellTextField class]]) {
                CSFormCellTextField *fCell = (CSFormCellTextField *)cell;
                [fCell.textField becomeFirstResponder];
            }
        } else {
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

#pragma mark - Validation Stuff

- (void)invalidateCellForField:(CSFormField *)field
{
    NSIndexPath *indexPath = [self indexPathForField:field];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[CSFormCell class]]) {
        CSFormCell *formCell = (CSFormCell *)cell;
        [formCell invalidate];
#warning ALSO scroll to tableview area that has cell
    }
}

- (CSFormValueValidator *)failedValidator
{
    for (CSFormSection *section in self.sections) {
        CSFormValueValidator *failedValidator;
        CSFormField *validationFailedField = [section fieldFailedWithValidator:&failedValidator];
        if (validationFailedField && failedValidator) {
#warning INVALIDATE the field here (so that when cells are recreated, styles persist)
            [self invalidateCellForField:validationFailedField];
            return failedValidator;
        }
    }
    return nil;
}

#pragma mark - Data Stuff

//perhaps populate server info? (since it's server value :P)
- (NSMutableDictionary *)populateUserInfo:(NSMutableDictionary *)userInfo
{
    for (CSFormSection *section in self.sections) {
        userInfo = [section populateUserInfo:userInfo];
    }
    return userInfo;
}

#pragma mark - Find Section

- (CSFormSection *)sectionForField:(CSFormField *)aField
{
    for (CSFormSection *section in self.sections) {
        if ([section containsField:aField]) {
            return section;
        }
    }
    return nil;
}

- (BOOL)haveSection:(CSFormSection *)sectionToFind
{
    for (CSFormSection *section in self.sections) {
        if ([sectionToFind isEqual:section]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Hide / Show Fields

- (void)hideFields:(NSArray *)fieldsToHide inSection:(CSFormSection *)section
{
    if (!fieldsToHide || ![self haveSection:section]) {
        return;
    }
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    //first we collect the indexPaths (because removing them from the sections will affect those)
    for (CSFormField *fieldToHide in fieldsToHide) {
        NSIndexPath *indexPath = [self indexPathForField:fieldToHide];
        //if field isn't actually present
        if (!indexPath) {
            continue;
        }
        
        [indexPaths addObject:indexPath];
        if ([fieldToHide isKindOfClass:[CSFormFieldExpandable class]]
            && [(CSFormFieldExpandable *)fieldToHide isExpanded]) {
            [indexPaths addObject:[self indexPathAfter:indexPath]];
            [(CSFormFieldExpandable *)fieldToHide setIsExpanded:NO];
        }
    }
    
    //now we actually remove them
    for (CSFormField *fieldToHide in fieldsToHide) {
        [section removeField:fieldToHide];
    }
    
    //set the isExpanded flag of the hidden fields back to NO so they come back collapsed
    for (CSFormField *fieldToHide in fieldsToHide) {
        if ([fieldToHide isKindOfClass:[CSFormFieldExpandable class]]
            && [(CSFormFieldExpandable *)fieldToHide isExpanded]) {
            [(CSFormFieldExpandable *)fieldToHide setIsExpanded:NO];
        }
    }

    //delete fields BEFORE deleting the section
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];

    //if the section is now empty, remove it!
    if ([section numberOfFields] == 0) {
        NSUInteger sectionIndex = [self removeSection:section];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)showFields:(NSArray *)fieldsToShow inSection:(CSFormSection *)section forSwitchSection:(CSFormSection *)switchSection
{
    if (!fieldsToShow) {
        return;
    }
    
    if (![self haveSection:section]) {
        NSInteger sectionIndex = [self insertSection:section afterSection:switchSection];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
    }
    
    NSIndexPath *lowestIndexPath;
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (CSFormField *fieldToShow in fieldsToShow) {
        NSIndexPath *indexPath = [self indexPathForField:fieldToShow];
        //if field is actually already present
        if (indexPath) {
            continue;
        }
        
        [section addField:fieldToShow];
        indexPath = [self indexPathForField:fieldToShow];
        [indexPaths addObject:indexPath];

        // if the lowest index path hasn't been set, or this is lower than it
        if (!lowestIndexPath || indexPath.row > lowestIndexPath.row) {
            lowestIndexPath = indexPath;
        }
    }
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:lowestIndexPath
                          atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)hideFieldsInMapTable:(NSMapTable *)fieldsToHide
{
    NSArray *keys = [[fieldsToHide keyEnumerator] allObjects];
    for (CSFormSection *section in keys) {
        NSArray *fields = [fieldsToHide objectForKey:section];
        [self hideFields:fields inSection:section];
    }
}

- (void)showFieldsInMapTable:(NSMapTable *)fieldsToShow forSwitchSection:(CSFormSection *)switchSection
{
    NSArray *keys = [[fieldsToShow keyEnumerator] allObjects];
    for (CSFormSection *section in keys) {
        NSArray *fields = [fieldsToShow objectForKey:section];
        [self showFields:fields inSection:section forSwitchSection:switchSection];
    }
}

#pragma mark - Unsorted
#pragma mark -
#pragma mark - Text Field Cell Delegate

- (BOOL)shouldReturnOnTextFieldCell:(CSFormCellTextField *)cell
{
    CSFormField *nextField = [self nextFieldToCell:cell];
    if (nextField) {
        [self makeFirstResponder:nextField];
    } else {
        [self.viewController pressedNext];
    }
    return YES;
}

- (void)didBeginEditingOnTextFieldCell:(CSFormCellTextField *)cell
{
    [self collapseCurrentlyExpandedField];
}

#pragma mark - Image Field Delegate

- (UIViewController  *)viewControllerToPresentOn
{
    return self.viewController.navigationController;
}

- (void)didPickImageOnField:(CSFormField *)aField
{
    NSIndexPath *ip = [self indexPathForField:aField];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
    if ([cell isKindOfClass:[CSFormCellImage class]]) {
        CSFormCellImage *imageCell = (CSFormCellImage *)cell;
        [imageCell fillThumbnailImage:[aField.value imageValue]];
    }
}

#pragma mark - Modal Picker Field Delegate

- (void)didSelectItemOnModalPicker
{
    [self.tableView reloadData];
}

#pragma mark - Switch Field Delegate

- (void)didChangeValueOfSwitchOnField:(CSFormFieldSwitch *)aField toOn:(BOOL)on
{
    CSFormSection *switchSection = [self sectionForField:aField];
    if (!switchSection) {
        return;
    }
    
    if (on) {
        [self hideFieldsInMapTable:aField.fieldsToHideOnOn];
        [self showFieldsInMapTable:aField.fieldsToShowOnOn forSwitchSection:switchSection];
    } else {
        [self hideFieldsInMapTable:aField.fieldsToShowOnOn];
        [self showFieldsInMapTable:aField.fieldsToHideOnOn forSwitchSection:switchSection];
    }
}

#pragma mark - Toggle Field Delegate

- (void)didSelectSegmentIndex:(NSInteger)selectedIndex onField:(CSFormField *)aField
{
    //content switching stuff here
}

@end
