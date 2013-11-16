//
//  ImageFieldsForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "ImageFieldsForm.h"

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"

@interface ImageFieldsForm () <CSFormCellImageStyleProvider>
- (IBAction)completeForm:(id)sender;
- (void)setCellHeight:(CGFloat)height;
@end

@implementation ImageFieldsForm {
    CGFloat _height;
    CSFormCellImageLabelStyle _labelStyle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createForm];
}

#pragma mark -
#pragma mark Form Creation

- (void)createForm
{
    NSArray *thumbnailStyles = @[@(CSFormCellImageThumbnailStyleCircle),
                                 @(CSFormCellImageThumbnailStyleSquare),
                                 @(CSFormCellImageThumbnailStyleScaled)];
    
    CGFloat smallSide = 100.f;
    CGFloat standardSide = 320.f;
    CGFloat mediumSide = 640.f;
    CGFloat largeSide = 1280.f;
    
    NSValue *smallSquareSize = [NSValue valueWithCGSize:CGSizeMake(smallSide, smallSide)];
    NSValue *standardSquareSize = [NSValue valueWithCGSize:CGSizeMake(standardSide, standardSide)];
    NSValue *mediumSquareSize = [NSValue valueWithCGSize:CGSizeMake(mediumSide, mediumSide)];
    NSValue *largeSquareSize = [NSValue valueWithCGSize:CGSizeMake(largeSide, largeSide)];

    NSValue *smallPortraitSize = [NSValue valueWithCGSize:CGSizeMake(smallSide / 2.f, smallSide)];
    NSValue *standardPortraitSize = [NSValue valueWithCGSize:CGSizeMake(standardSide / 2.f, standardSide)];
    NSValue *mediumPortraitSize = [NSValue valueWithCGSize:CGSizeMake(mediumSide / 2.f, mediumSide)];
    NSValue *largePortraitSize = [NSValue valueWithCGSize:CGSizeMake(largeSide / 2.f, largeSide)];

    NSValue *smallLandscapeSize = [NSValue valueWithCGSize:CGSizeMake(smallSide, smallSide / 2.f)];
    NSValue *standardLandscapeSize = [NSValue valueWithCGSize:CGSizeMake(standardSide, standardSide / 2.f)];
    NSValue *mediumLandscapeSize = [NSValue valueWithCGSize:CGSizeMake(mediumSide, mediumSide / 2.f)];
    NSValue *largeLandscapeSize = [NSValue valueWithCGSize:CGSizeMake(largeSide, largeSide / 2.f)];

    NSArray *sizesArray = @[mediumSquareSize, mediumLandscapeSize, mediumPortraitSize,
                            smallSquareSize, smallLandscapeSize, smallPortraitSize,
                            largeSquareSize, largeLandscapeSize, largePortraitSize,
                            standardSquareSize, standardLandscapeSize, standardPortraitSize];
    for (NSValue *sizeValue in sizesArray) {
        NSString *title = [NSString stringWithFormat:@"%d x %d", (int)sizeValue.CGSizeValue.width, (int)sizeValue.CGSizeValue.height];
        [self addSection:[self exampleFieldsSectionWithTitle:title
                                                   imageSize:sizeValue.CGSizeValue
                                              thumbnailSizes:thumbnailStyles]];
    }    
}

- (AKFormSection *)exampleFieldsSectionWithTitle:(NSString *)title
                                       imageSize:(CGSize)imageSize
                                  thumbnailSizes:(NSArray *)thumbnailSizes
{
    NSMutableArray *fields = [NSMutableArray array];
    for (int i=0; i<thumbnailSizes.count; i++) {
        AKFormFieldImage *field = [AKFormFieldImage fieldWithKey:[NSString stringWithFormat:@"image_%d", i+1]
                                                            title:[NSString stringWithFormat:@"Image %d", i+1]
                                                      placeholder:[NSString stringWithFormat:@"Choose Image %d", i+1]
                                                        imageSize:imageSize
                                                   thumbnailStyle:((NSNumber *)thumbnailSizes[i]).integerValue
                                                   formController:self];
        NSString *failMessage = [NSString stringWithFormat:@"Please choose image %d", i+1];
        AKFormValidator *validator = [AKFormValidator requiredBlockWithFailMessage:failMessage];
        field.validators = @[validator];
        [fields addObject:field];
    }
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = title;
    return section;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - Completing a Form

- (IBAction)completeForm:(id)sender
{
    if ([super validateForm]) {
        [[[UIAlertView alloc] initWithTitle:@"Passed"
                                    message:@"Validation Passed"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark -
#pragma mark Image Cell—Style Provider

- (UIFont *)imageCell:(AKFormCellImage *)cell labelFontForMode:(CSFormCellImageMode)mode
{
    return [UIFont systemFontOfSize:17.f];
}

- (UIColor *)imageCell:(AKFormCellImage *)cell labelTextColorForMode:(CSFormCellImageMode)mode
{
    switch (mode) {
        case CSFormCellImageModeEmpty:
            return [UIColor colorWithHexString:HEX_COLOR_GREY_PLACEHOLDER];
        case CSFormCellImageModeFilled:
        case CSFormCellImageModeReadOnly:
            return [UIColor darkGrayColor];
            break;
    }
}

- (UIImage *)placeholderImageForImageCell:(AKFormCellImage *)cell
{
    return [UIImage imageNamed:@"PlaceholderProfile2"];
}

- (CGFloat)heightForImageCell:(AKFormCellImage *)cell
{
    return _height;
}

- (void)setCellHeight:(CGFloat)height
{
    _height = height;
    [self.tableView reloadData];
}

- (void)setLabelStyle:(CSFormCellImageLabelStyle)labelStyle
{
    _labelStyle = labelStyle;
    [self.tableView reloadData];
}

- (CSFormCellImageLabelStyle)labelStyleForImageCell:(AKFormCellImage *)cell
{
    return _labelStyle;
}


@end


#define MIN_CELL_HEIGHT 30.f
#define MAX_CELL_HEIGHT 300.f

@interface ImageFieldsFormContainer ()
@property(nonatomic, strong) IBOutlet ImageFieldsForm *form;
- (IBAction)pressedValidate:(id)sender;
@end

@implementation ImageFieldsFormContainer

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl setSelectedSegmentIndex:1];
    [self.segmentedControl setSelectedSegmentIndex:2];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self segmentedControlDidChangeSelectedSegmentIndex:self.segmentedControl];
}

- (IBAction)segmentedControlDidChangeSelectedSegmentIndex:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.form setLabelStyle:CSFormCellImageLabelStyleLeft];
            break;
        case 1:
            [self.form setLabelStyle:CSFormCellImageLabelStyleNone];
            break;
        case 2:
            [self.form setLabelStyle:CSFormCellImageLabelStyleRight];
            break;
        default:
            [self.form setLabelStyle:CSFormCellImageLabelStyleNone];
            break;
    }
}

- (IBAction)pressedValidate:(id)sender
{
    [self.form completeForm:sender];
}

- (IBAction)sliderValueDidChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    CGFloat height = ((MAX_CELL_HEIGHT - MIN_CELL_HEIGHT) * slider.value) + MIN_CELL_HEIGHT;
    [self.form setCellHeight:height];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"form_embed"]) {
        self.form = (ImageFieldsForm *) [segue destinationViewController];

        CGFloat sliderValue = (100.f - MIN_CELL_HEIGHT) / (MAX_CELL_HEIGHT - MIN_CELL_HEIGHT);
        [self.slider setValue:sliderValue];
        [self sliderValueDidChange:self.slider];
    }
}
@end