#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"
#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPExtensionManager.h"
#include "HPUtility.h"
%hook SBIconView 

// Icon Scale & Alpha

- (void)layoutSubviews 
{
    %orig;

    NSInteger loc = MSHookIvar<NSInteger>(self, "_iconLocation");
    NSString *x = @"";

    switch ( loc )
    {
        case 1: 
        {   
            x = @"Root";
            break;
        }
        case 3: 
        {
            x = @"Dock";
            break;
        }
        case 6: 
        {
            x = @"Folder";
            break;
        }
        default: 
        {
            x = @"Folder";
            break;
        }
    }

    CGFloat sx = ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", x, @"Scale"]]?:60.0f) / 60.0f;
    [self.layer setSublayerTransform:CATransform3DMakeScale(sx, sx, 1)];

    if (self.alpha != 0) self.alpha = (([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", x, @"IconAlpha"]]?:100.0f) / 100.0f);
}

%end


%hook SBIconBadgeView

// Hide Icon Badges

- (void)setHidden:(BOOL)arg
{
    if ([[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPDataIconBadges"])
    {
        %orig(YES);
    }
    else {
        %orig(arg);
    }
}

- (BOOL)isHidden 
{
    if ([[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPDataIconBadges"])
    {
        return YES;
    }
    return %orig;
}

- (CGFloat)alpha
{    
    CGFloat a = ([[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPDataIconBadges"]) ? 0.0 : %orig;

    return a;
}

- (void)setAlpha:(CGFloat)arg
{   
    %orig([[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPDataIconBadges"] ? 0.0 : arg);
}

%end


%hook SBIconLegibilityLabelView

// Hide Icon Labels

- (void)setHidden:(BOOL)arg1 
{
    BOOL hide = NO;

    if (((SBIconLabelImage *)self.image).parameters.iconLocation == 1) // this works, somehow. 
    {
        // home screen
        hide = [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataIconLabels"]?:0 == 1;
    } 
    else if (((SBIconLabelImage *)self.image).parameters.iconLocation == 6)
    {
        // folder
        hide = [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataIconLabelsF"]?:0 == 1;
    }

    // If we aren't hiding it but SB is, listen to springboard
    %orig((hide || arg1));
}

%end


%ctor {
    if (kCFCoreFoundationVersionNumber < 1600) %init;
}