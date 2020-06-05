#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"

#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPExtensionManager.h"
#include "HPUtility.h"
#pragma mark Dynamic Window Background

%hook UIRootSceneWindow

//
// iOS 13 - Dynamic editor background
// We use this to set the background image for the editor
//

- (id)initWithDisplay:(id)arg
{
    id o = %orig(arg);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:@"CreateBackgroundObject" object:nil];

    return o;
}

- (id)initWithDisplayConfiguration:(id)arg
{
    id o = %orig(arg);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:@"CreateBackgroundObject" object:nil];

    return o;
}

- (id)initWithScreen:(id)arg
{
    id o = %orig(arg);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:@"CreateBackgroundObject" object:nil];

    return o;
}

%new
- (void)recieveNotification:(NSNotification *)notification
{
    self.backgroundColor = [UIColor colorWithPatternImage:[HPEditorManager sharedInstance].blurredAndDarkenedWallpaper];
}

%end


%ctor {
if (kCFCoreFoundationVersionNumber > 1600) %init;
}