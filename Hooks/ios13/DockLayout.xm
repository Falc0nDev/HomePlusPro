#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"
#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPExtensionManager.h"
#include "HPUtility.h"
@interface SBDockIconListView : UIView
- (CGFloat)effectiveSpacingForNumberOfIcons:(NSUInteger)num;
- (NSUInteger)iconsInRowForSpacingCalculation;
- (NSUInteger)iconColumnsForCurrentOrientation;
- (id)layout;
@end
#pragma mark Dock Handling

%hook SBDockIconListView 

- (UIEdgeInsets)layoutInsets
{
    if ([HPManager sharedInstance]._tcDockyInstalled)return %orig;

    if (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPDockConfigEnabled"]) return %orig;

    return [[[self layout] layoutConfiguration] portraitLayoutInsets];
}

- (BOOL)automaticallyAdjustsLayoutMetricsToFit
{
    [[[self layout] layoutConfiguration] portraitLayoutInsets];
    return NO;
}

- (CGFloat)horizontalIconPadding
{
    if ([HPManager sharedInstance]._tcDockyInstalled) return %orig;
    if (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPDockConfigEnabled"]) return %orig;
    return [[[HPDataManager sharedInstance] currentConfiguration] floatForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", @"Dock", @"SideInset"]];
}

- (NSUInteger)iconRowsForCurrentOrientation
{
    if ([HPManager sharedInstance]._tcDockyInstalled) return %orig;[[[self layout] layoutConfiguration] portraitLayoutInsets];

    if (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPDockConfigEnabled"]) return %orig;

    SBIconListGridLayoutConfiguration *config = [[self layout] layoutConfiguration];
    return [config numberOfPortraitRows];
}

- (NSUInteger)iconColumnsForCurrentOrientation
{
    if ([HPManager sharedInstance]._tcDockyInstalled) return %orig;[[[self layout] layoutConfiguration] portraitLayoutInsets];

    if (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPDockConfigEnabled"]) return %orig;

    SBIconListGridLayoutConfiguration *config = [[self layout] layoutConfiguration];
    return [config numberOfPortraitColumns];
}
/*
-(CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 numberOfIcons:(NSUInteger)arg2 {
    if ([self iconRowsForCurrentOrientation] == 1 && [self iconColumnsForCurrentOrientation] == 4) return %orig;
/*
    CGSize size = CGSizeMake(60,60);
    iconSize = size;
    *
    return %orig;
    /*
    if (dockMode == 3) 
    {
        CGPoint orig = %orig;
        CGFloat x = infiniteSpacing;
        
        if (infinitePaging) {
            int max = (fiveIcons) ? 5 : 4;
            CGFloat offset = (dockScrollView.frame.size.width - max * (size.width + infiniteSpacing))/2;
            x = offset * (ceil((arg1.col - 1)/max)*2 + 1);
        }

        return CGPointMake(((size.width + infiniteSpacing) * (arg1.col - 1)) + x + infiniteSpacing/2, orig.y);
    }
    
    CGFloat top = [%c(SBRootFolderDockIconListView) defaultHeight] - size.height * 1.2;

    CGFloat x = (size.width + (fiveIcons ? 5 : 20)) * (arg1.col - 1) + (fiveIcons ? 25 : 35);
    CGFloat y = (size.height + [dockView dockHeightPadding]/2 + 15) * (arg1.row - 1) + top;
    
    if (ipx) {
        top = [%c(SBRootFolderDockIconListView) defaultHeight] - [dockView dockHeightPadding] - size.height * 1.2;
        y = (size.height + [dockView dockHeightPadding] + 2 + 15) * (arg1.row - 1) + top;
    }
    
    return CGPointMake(x, y);
    *
}*/
%end


%ctor {
if (kCFCoreFoundationVersionNumber > 1600) %init;
}