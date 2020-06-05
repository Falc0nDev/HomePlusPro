#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"

#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPExtensionManager.h"
#include "HPUtility.h"
%hook SBFloatingDockView 
- (void)layoutSubviews 
{
    %orig;
    [HPManager sharedInstance].floatingDockWindow = self.superview.superview.superview.superview;
}
%end


#pragma mark FloatyDock Handling

%hook SBMainScreenActiveInterfaceOrientationWindow

// Hide FloatyDock View when it is appropriate to do so

- (id)_initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 rootViewController:(id)arg4 scene:(id)arg5
{
    id o = %orig(arg1, arg2, arg3, arg4, arg5);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeDisabledNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeEnabledNotificationName object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fader:) name:kFadeFloatingDockNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fader:) name:kShowFloatingDockNotificationName object:nil];

    //if ([self isActive]) [HPManager sharedInstance].floatingDockWindow = self;

    return o;
}

- (id)initWithDebugName:(id)arg
{
    id o = %orig(arg);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeDisabledNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeEnabledNotificationName object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fader:) name:kFadeFloatingDockNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fader:) name:kShowFloatingDockNotificationName object:nil];

    //if ([self isActive]) [HPManager sharedInstance].floatingDockWindow = self;
    
    
    return o;
}
- (BOOL)isActive
{
    BOOL x = %orig;
    if (x)
    {
        //[HPManager sharedInstance].floatingDockWindow = self;
    }
    return x;
}
%new 
- (void)fader:(NSNotification *)notification
{
    [UIView animateWithDuration:.2 
        animations:
        ^{
            self.alpha = ([[notification name] isEqualToString:kFadeFloatingDockNotificationName]) ? 0 : 1;
        }
    ];
}

%new
- (void)recieveNotification:(NSNotification *)notification
{
    BOOL enabled = ([[notification name] isEqualToString:kEditingModeEnabledNotificationName]);

    [HPManager sharedInstance]._rtEditingEnabled = enabled;

    self.userInteractionEnabled = !enabled;
}

%end


%ctor {
    if (kCFCoreFoundationVersionNumber < 1600) %init;
}