#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"
#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPExtensionManager.h"
#include "HPUtility.h"


#pragma mark Icon Handling

%hook SBIconView

- (void)layoutSubviews
{
    %orig;
    NSString *x = @"";
    if ([[self location] isEqualToString:@"SBIconLocationRoot"]) x = @"Root";
    else if ([[self location] isEqualToString:@"SBIconLocationDock"]) x = @"Dock";
    else x = @"Folder";

    CGFloat sx = ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", x, @"Scale"]]?:60.0) / 60.0;
    [self.layer setSublayerTransform:CATransform3DMakeScale(sx, sx, 1)];
    //[self setIconContentScalingEnabled:YES];
    //[self setIconContentScale:([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString
        //stringWithFormat:@"%@%@%@", @"HPData", x, @"Scale"]]?:60.0) / 60.0];
    if (([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", x, @"IconAlpha"]]?:100.0f)!= 0.0
            && self.alpha != 0)
        self.alpha = (([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", x, @"IconAlpha"]]?:100.0f) / 100.0f);
}

%end 


%hook SBIconLegibilityLabelView

- (void)setHidden:(BOOL)arg
{
    @try
    {
        SBIconView *superv = (SBIconView *)self.superview;
        NSString *x = @"";

        if ([[superv location] isEqualToString:@"SBIconLocationRoot"]) x = @"";
        else if ([[superv location] isEqualToString:@"SBIconLocationFolder"]) x = @"F";

        if ([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@", @"HPDataIconLabels", x]])
        {
            %orig(YES);
        }
        else {
            %orig(arg);
        }
    } 
    @catch (NSException *ex)
    {
        // Icon being dragged
        %orig(arg);
    }
}

- (BOOL)isHidden 
{
    @try 
    {
        SBIconView *superv = (SBIconView *)self.superview;
        NSString *x = @"";
        if ([[superv location] isEqualToString:@"SBIconLocationRoot"]) x = @"";
        else if ([[superv location] isEqualToString:@"SBIconLocationFolder"]) x = @"F";
        if ([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@", @"HPDataIconLabels", x]])
        {
            return YES;
        }
        return %orig;
    } 
    @catch (NSException *ex)
    {
        // Icon being dragged
        return %orig;
    }
}

- (CGFloat)alpha
{
    @try 
    {
        SBIconView *superv = (SBIconView *)self.superview;
        NSString *x = @"";
        if ([[superv location] isEqualToString:@"SBIconLocationRoot"]) x = @"";
        else if ([[superv location] isEqualToString:@"SBIconLocationFolder"]) x = @"F";
        return ([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@", @"HPDataIconLabels", x]]) ? 0.0 : %orig;
    } 
    @catch (NSException *ex)
    {
        // Icon Being Dragged
        return %orig;
    }
}

- (void)setAlpha:(CGFloat)arg
{
    @try 
    {
        SBIconView *superv = (SBIconView *)self.superview;
        NSString *x = @"";
        if ([[superv location] isEqualToString:@"SBIconLocationRoot"]) x = @"";
        else if ([[superv location] isEqualToString:@"SBIconLocationFolder"]) x = @"F";
        %orig(([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@", @"HPDataIconLabels", x]]) ? 0.0 : arg);
    } 
    @catch (NSException *ex)
    {
        // Icon being dragged
        %orig(arg);
    }
}

%end


%hook SBIconBadgeView

- (void)setHidden:(BOOL)arg
{
    if ([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataIconBadges"])
    {
        %orig(YES);
    }
    else 
    {
        %orig(arg);
    }
}

- (BOOL)isHidden 
{
    if ([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataIconBadges"])
    {
        return YES;
    }

    return %orig;
}

- (CGFloat)alpha
{
    return (([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataIconBadges"]?:0) == 0) ? %orig : 0;
}

- (void)setAlpha:(CGFloat)arg
{
    %orig((([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataIconBadges"]?:0) == 0) ? arg : 0);
}

%end


%ctor {
if (kCFCoreFoundationVersionNumber > 1600) %init;
}