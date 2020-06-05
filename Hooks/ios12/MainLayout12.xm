#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"
#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPUtility.h"
%hook SBRootIconListView 

%property (nonatomic, assign) BOOL configured;

- (void)layoutSubviews 
{
    %orig;

    if (!self.configured) 
    {

        [[[HPEditorManager sharedInstance] editorViewController] addRootIconListViewToUpdate:self];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutIconsNow) name:@"HPLayoutIconViews" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutIconsNowWithAnimation) name:@"HPLayoutIconViewsAnimated" object:nil];

        self.configured = YES;
        [HPManager sharedInstance]._rtConfigured = YES;
    }
}

%new 
- (void)layoutIconsNowWithAnimation
{
    [UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIconsNow];
    } completion:NULL];
}

- (void)layoutIconsNow 
{
    %orig;
    
    // Trigger the icon label alpha function we hook
    [self setIconsLabelAlpha:1.0f];
}

- (CGFloat)horizontalIconPadding 
{
    CGFloat x = %orig;

    if (!self.configured) 
    {
        return x;
    }

    BOOL buggedSpacing = ((([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataRootColumns"]?:4) == 4)
                                && ([[HPUtility deviceName] isEqualToString:@"iPhone X"])); // Afaik, the "Boxy" bug only happens on iOS 12 iPX w/ 4 columns
                                                                                  // We dont need to check version because we're in a group block
                                                                                  //    that only executes on iOS 12 and below
                         

    BOOL leftInsetZeroed = ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataRootLeftInset"]?:0.0f) == 0.0f; // Enable more intuitive behavior
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0f)
    {
        // This gets confusing and is the result of a lot of experimentation
        if (buggedSpacing)
        {
            return -100.0f; // When the boxy bug happens, its triggered by this value being more than 0
                           //   From what I remember writing this, the lower the value, the more we can adjust the 
                           //   "Horizontal Spacing" aka "Side Inset"
        }
        if (leftInsetZeroed) 
        {
            // If the left inset is 0, return the original value here. Then, iOS will dynamically calculate this value based upon
            //    the Value of -(CGFloat)sideIconInset. This is hard to make clear with code, but the behavioral simplicity it gives
            //    is simply amazing. 
            return x; 
        }
        else
        {
            // In the event that Left Spacing is not zeroed, we'll do things Boxy style. 
            // What happens here is that this legitimately changes icon padding. 
            // It is near impossible to center; That is what some people want when they change
            // the left offset, so now, this function isn't dynamically calculated, its manually set by the user.
            return [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataRootSideInset"]?:0.0f;
        }
    }
    else 
    {
        // on iOS 11, do things Boxy style. I need to do further testing to see if iOS 11 supports the cool
        //      calculations we used on iOS 12
        return [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataRootSideInset"]?:0.0f;
    }
}

- (CGFloat)verticalIconPadding 
{
    CGFloat x = %orig;

    if (!self.configured) return x;
     
    return x+[[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataRootVerticalSpacing"]?:0.0f;
}

- (CGFloat)sideIconInset
{   
    // This is the other half of the complex stuff in horizontalIconPadding
    CGFloat x = %orig;

    if (!self.configured)
    {
        return x;
    }

    BOOL buggedSpacing = ((([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPDataRootColumns"]?:4) == 4) && ([[HPUtility deviceName] isEqualToString:@"iPhone X"])); // Afaik, the "Boxy" bug only happens on iOS 12 iPX w/ 4 columns
                                                                                  // We dont need to check version because we're in a group block
                                                                                  //    that only executes on iOS 12 and below
                         

    BOOL leftInsetZeroed = ([[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataRootLeftInset"]?:0.0f) == 0.0f; // Enable more intuitive behavior

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0f)
    {
        if (leftInsetZeroed || buggedSpacing) 
        {
            return x + [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataRootSideInset"]?:0.0f;  // Here's the fix I found for the iPX 4col bug
                                                                                                            // Essentially, we can create the "HSpacing"/Side Inset
                                                                                                            //      by returning it here (along w/ hIP returning -100)
        }
        else
        {
            return [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataRootLeftInset"]?:0.0f;      // Otherwise, return the Left Inset for here, on normal devices
        }
    }
    else
    {
        return [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataRootLeftInset"]?:0.0f; // Just return Left Inset on iOS 12
    }  
}

- (CGFloat)topIconInset
{
    CGFloat x = %orig;

    if (!self.configured)
    {
        return x;
    }
    // These really shouldn't need much explaining
    // But fuck it; In boxy/cuboid and early versions of this tweak, i let users modify the value that was returned
    // Now, to make everything massively easier on both users and me, I return the original value and let the user
    //          add and subtract from that value. So, setting things to 0 means iOS defaults :)
    return x + [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:@"HPDataRootTopInset"]?:0.0f;
}

+ (NSUInteger)iconColumnsForInterfaceOrientation:(NSInteger)arg1
{
    NSInteger x = %orig(arg1);

    if (![HPManager sharedInstance]._rtConfigured)
    {
        return x;
    }

    NSString *landscape = YES ? @"" : @"Landscape";
    landscape = [HPUtility deviceRotatable] ? landscape : @"";
    
    // NSUInteger -> NSInteger doesn't require casts, just dont give it a negative value and its fine. 
    return [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@%@", @"HPDataRoot", landscape, @"Columns"]]?:x;
}

+ (NSUInteger)iconRowsForInterfaceOrientation:(NSInteger)arg1
{
    NSInteger x = %orig(arg1);

    if (arg1==69)
    {
        return %orig(1);
    }

    if (![HPManager sharedInstance]._rtConfigured)
    {
        return x;
    }

    NSString *landscape = YES ? @"" : @"Landscape";
    landscape = [HPUtility deviceRotatable] ? landscape : @"";


    return [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@%@", @"HPDataRoot", landscape, @"Rows"]]?:x;
}

+ (NSUInteger)maxVisibleIconRowsInterfaceOrientation:(NSInteger)arg1
{

    NSString *landscape = YES ? @"" : @"Landscape";
    landscape = [HPUtility deviceRotatable] ? landscape : @"";

    // Allow more than 24 icons on the SB w/o a reload
    if (([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@%@", @"HPDataRoot", landscape, @"Rows"]]?:[HPUtility defaultRows] == [HPUtility defaultRows])
        && (([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@%@", @"HPDataRoot", landscape, @"Columns"]]?:4) == 4))
    {
        return %orig;
    }

    return ([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@%@", @"HPDataRoot", landscape, @"Rows"]]?: [HPUtility defaultRows]);
}

%new 
- (NSUInteger)iconRowsForHomePlusCalculations
{
    // We use this to get the default row count from within the class. 
    // This same method can also be used to get the default from elsewhere. 
    return [[self class] iconRowsForInterfaceOrientation:69];
}

- (NSUInteger)iconRowsForSpacingCalculation
{
    NSInteger x = %orig;

    if (!self.configured)
    {
        return x;
    }

    NSString *landscape = YES ? @"" : @"Landscape";
    landscape = [HPUtility deviceRotatable] ? landscape : @"";


    return [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@%@", @"HPDataRoot", landscape, @"Rows"]] ?: x;
}

%end


%ctor {
    if (kCFCoreFoundationVersionNumber < 1600) %init;
}