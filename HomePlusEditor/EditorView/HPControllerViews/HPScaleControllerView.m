//
// HPScaleControllerView.m
// HomePlus
//
// Controller View for editing Icon Scale/Alpha
//
// Author:  Kritanta
// Created: Dec 2019
//

#include "../HPControllerView.h"
#include "../HPEditorViewController.h"
#include "../../Data/HPConfiguration.h"
#include "../../Managers/HPDataManager.h"
#include "../../Managers/HPEditorManager.h"
#include "../../Utility/HPUtility.h"

@implementation HPScaleControllerView

/*
Properties: 
    @property (nonatomic, retain) UIView *topView;
    @property (nonatomic, retain) UIView *bottomView;

    @property (nonatomic, retain) UILabel *topLabel;
    @property (nonatomic, retain) OBSlider *topControl;
    @property (nonatomic, retain) UITextField *topTextField;

    @property (nonatomic, retain) UILabel *bottomLabel;
    @property (nonatomic, retain) OBSlider *bottomControl;
    @property (nonatomic, retain) UITextField *bottomTextField;
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) 
    {
        [self layoutControllerView];
    }

    return self;
}

-(void)layoutControllerView
{
    [super layoutControllerView];

    NSString *x = [[[HPEditorManager sharedInstance] editingLocation] substringFromIndex:14];

    self.topLabel.text = [HPUtility localizedItem:@"ICON_SCALE"];
    self.bottomLabel.text = [HPUtility localizedItem:@"ICON_ALPHA"];

    self.topControl.minimumValue = 1;
    self.topControl.maximumValue = 100;

    self.bottomControl.minimumValue = 0;
    self.bottomControl.maximumValue = 100.0;


    self.topControl.value = [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"HPData%@%@", x, @"Scale"]];
    self.topTextField.text = [NSString stringWithFormat:@"%.0f", [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"HPData%@%@", x, @"Scale"]]];
    self.bottomControl.value = [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"HPData%@%@", x, @"IconAlpha"]];
    self.bottomTextField.text = [NSString stringWithFormat:@"%.0f", [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"HPData%@%@", x, @"IconAlpha"]]];
    
}

- (void)topSliderUpdated:(UISlider *)sender
{
    NSString *x = [[[HPEditorManager sharedInstance] editingLocation] substringFromIndex:14];

    [[[HPDataManager sharedInstance] currentConfiguration] setFloat:sender.value
                                                             forKey:[NSString stringWithFormat:@"HPData%@%@", x, @"Scale"]];
    self.topTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];

    [[[HPEditorManager sharedInstance] editorViewController] layoutAllSpringboardIcons];
}

- (void)bottomSliderUpdated:(UISlider *)sender
{
    NSString *x = [[[HPEditorManager sharedInstance] editingLocation] substringFromIndex:14];

    [[[HPDataManager sharedInstance] currentConfiguration] setFloat:sender.value
                                                             forKey:[NSString stringWithFormat:@"HPData%@%@", x, @"IconAlpha"]];
    self.bottomTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];

    [super bottomSliderUpdated:sender];
    [[[HPEditorManager sharedInstance] editorViewController] layoutAllSpringboardIcons];
}


- (void)handleTopResetButtonPress:(UIButton*)sender 
{
    [super handleTopResetButtonPress:sender];
    self.topControl.value = 60;
    [self topSliderUpdated:self.topControl];
}
- (void)handleBottomResetButtonPress:(UIButton*)sender 
{
    [super handleBottomResetButtonPress:sender];
    self.bottomControl.value = 100;
    [self bottomSliderUpdated:self.bottomControl];
}


@end