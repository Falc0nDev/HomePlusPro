#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"
#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPUtility.h"
%hook _SBWallpaperWindow 

// This hook copies a lot of the hooks from the HomeScreenWindow hook
// Although, it does not do anything related to the managers
// This exists so we can shrink the wallpaper alongside the icon list
// Documentation for anything this does can be found in the SBHomeScreenWindow hook

- (id)_initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 rootViewController:(id)arg4 scene:(id)arg5
{
    id o = %orig(arg1, arg2, arg3, arg4, arg5);
    
    [HPManager sharedInstance].wallpaperView = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeEnabledNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeDisabledNotificationName object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kicker:) name:kEditorKickViewsUp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kicker:) name:kEditorKickViewsBack object:nil];

    return o;
}

%new 
- (void)kicker:(NSNotification *)notification
{
    return;
    CGAffineTransform transform = self.transform;

    [UIView animateWithDuration:.4
    animations:
    ^{
        self.transform = (([[notification name] isEqualToString:kEditorKickViewsUp])              
                        && ![HPManager sharedInstance]._rtKickedUp)
                                ? CGAffineTransformTranslate(transform, 0.0f, 
                                        (transform.ty == 0.0f                                          
                                            ? 0.0f - ([[UIScreen mainScreen] bounds].size.height * 0.7f) 
                                            : 0.0f                                                  
                                        ))                                                           
                                : CGAffineTransformTranslate(transform, 0, 
                                        (transform.ty == 0.0
                                            ? 0.0f                                                    
                                            : ([[UIScreen mainScreen] bounds].size.height * 0.7f)
                                        )); 
    }]; 
}

%new
- (void)recieveNotification:(NSNotification *)notification
{
    // Set a corner radius on notched devices to make things look cleaner
    BOOL enabled = ([[notification name] isEqualToString:kEditingModeEnabledNotificationName]);
    [HPManager sharedInstance]._rtEditingEnabled = enabled;
    BOOL notched = [HPUtility isCurrentDeviceNotched];
    CGFloat cR = notched ? 35 : 0;
    self.layer.cornerRadius = enabled ? cR : 0;
}

%end
