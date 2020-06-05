#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreGraphics/CGBase.h>
#include "HomePlus.h"
#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPUtility.h"
@interface SBDockIconListView : SBRootIconListView
@end
%hook SBDockIconListView

// Hook our dock icon list view
// For documentation on hooked methos see SbRootIconListView (ios 12)

%property (nonatomic, assign) BOOL configured;

- (void)layoutSubviews 
{
    %orig;

    if ([HPManager sharedInstance]._tcDockyInstalled) return;

    if (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"]) return %orig;

    if (!self.configured) 
    {
        [[[HPEditorManager sharedInstance] editorViewController] addRootIconListViewToUpdate:self];
        self.configured = YES;
        
    }
}

+ (NSUInteger)maxIcons 
{
    if ([HPManager sharedInstance]._tcDockyInstalled || (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"])) return %orig;

    return [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockColumns"] ?: 4.0f;
}

- (UIEdgeInsets)layoutInsets
{
    UIEdgeInsets x = %orig;

    if ((![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"]))
    {
        return x;
    }
    
    if ((!([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"LeftInset"]]?:0.0f)) == 0.0f)
    {
        return UIEdgeInsetsMake(
            x.top + ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"TopInset"]]?:0.0f),
            [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"LeftInset"]]?:0.0f,
            x.bottom - ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"TopInset"]]?:0.0f) + ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"VerticalSpacing"]]?:0.0f) *-2, // * 2 because regularly it was too slow
            x.right - ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"LeftInset"]]?:0.0f) + ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"SideInset"]]?:0.0f) *-2
        );
    }
    else
    {
        return UIEdgeInsetsMake(
            x.top + ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"TopInset"]]?:0.0f) ,
            x.left + ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"SideInset"]]?:0.0f)*-2,
            x.bottom - ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"TopInset"]]?:0.0f) + ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"VerticalSpacing"]]?:0.0f) *-2, // * 2 because regularly it was too slow
            x.right + ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"SideInset"]]?:0.0f)*-2
        );
    }
}

- (NSUInteger)iconsInRowForSpacingCalculation 
{
    if ([HPManager sharedInstance]._tcDockyInstalled || (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"])) return %orig;

    return [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataDockColumns"] ?: 4;
}

- (CGFloat)horizontalIconPadding 
{
    CGFloat x = %orig;

    if ([HPManager sharedInstance]._tcDockyInstalled || (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"]) || !self.configured) return %orig;

    BOOL buggedSpacing = ([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataDockColumns"]?:4) == 4 && [[HPUtility deviceName] isEqualToString:@"iPhone X"];
    BOOL leftInsetZeroed = [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockLeftInset"]?:0.0f == 0.0f;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0f)
    {
        if (buggedSpacing)
        {
            return -100.0f;
        }
        if (leftInsetZeroed) {
            return x;
        }
        else
        {
            return [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockSideInset"]?:0.0f;
        }
    }
    else 
    {
        return [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockSideInset"]?:0.0f;
    }
}

- (CGFloat)verticalIconPadding 
{
    CGFloat x = %orig;

    if (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"]) return %orig;
    if (!self.configured || [HPManager sharedInstance]._tcDockyInstalled) return x;

    return x + [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockVerticalSpacing"]?:0.0f;
}

- (CGFloat)sideIconInset
{   
    CGFloat x = %orig;

    if ([HPManager sharedInstance]._tcDockyInstalled || !([[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"])) return %orig;

    if (!self.configured)
    {
        return x;
    }

    BOOL buggedSpacing = [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockColumns"]?:4 == 4
                                        && [[HPUtility deviceName] isEqualToString:@"iPhone X"];
    BOOL leftInsetZeroed = [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockLeftInset"]?:0.0f == 0.0f;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0f)
    {
        if (leftInsetZeroed || buggedSpacing) 
        {
            return x + [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockSideInset"]?:0.0f;
        }
        else
        {
            return [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockLeftInset"]?:0.0f;
        }
    }
    else
    {
        return [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockSideInset"]?:0.0f;
    }
}

- (CGFloat)topIconInset
{
    if (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"]
            || ([HPManager sharedInstance]._tcDockyInstalled)
            || !self.configured)
    {
        return %orig;
    } 

    CGFloat x = %orig;
    
    return x + [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataDockTopInset"] ?: 0.0f;
}

+ (NSUInteger)iconColumnsForInterfaceOrientation:(NSInteger)arg1
{
    // Bad method name

    // This method returns rows



    if (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"]
            || [HPManager sharedInstance]._tcDockyInstalled || ![HPManager sharedInstance]._rtConfigured)
    {
        return %orig(arg1);
    }

    if (NO)
    {
        return [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataDockRows"]?:1;
    }

    return [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataDockColumns"] ?: 4;
}

- (NSUInteger)iconsInColumnForSpacingCalculation
{
    if (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"]
        || [HPManager sharedInstance]._tcDockyInstalled || ![HPManager sharedInstance]._rtConfigured)
    {
        return %orig;
    }

        if (NO)
    {
        return [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataDockColumns"]?:4;
    }

    return [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataDockRows"]?:1;
}

%end


%ctor {
    if (kCFCoreFoundationVersionNumber < 1600) %init;
}