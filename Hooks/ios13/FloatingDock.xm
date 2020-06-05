#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"

#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPExtensionManager.h"
#include "HPUtility.h"
#pragma mark FloatyDock Handling

%hook SBFloatingDockWindow

// Scale floaty docks with the rest of the views
// For some (maybe dumb, maybe not) reason, they get their own oddly named window
// on iOS 13, the window is renamed, but it subclasses this one, so we're still good
//      (for now)
// This mostly mocks the handling of SBHomeScreenWindow, most documentation can be found there
- (id)_initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 rootViewController:(id)arg4 scene:(id)arg5
{
    id o = %orig(arg1, arg2, arg3, arg4, arg5);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeDisabledNotificationName object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fader:) name:kFadeFloatingDockNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fader:) name:kShowFloatingDockNotificationName object:nil];

    [HPManager sharedInstance].floatingDockWindow = self;

    return o;
}

%new 
- (void)fader:(NSNotification *)notification
{
    // In the settings view and keyboard view, floatydock (annoyingly) sits above it. 
    // So we need to fade it at times using a notification. 
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
if (kCFCoreFoundationVersionNumber > 1600) %init;
}