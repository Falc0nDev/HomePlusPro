#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"
%hook SBRootFolderController

// Disable Icon Wiggle when Editor is loaded

- (void)viewDidLoad
{
    %orig;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableWiggle:) name:kDisableWiggleTrigger object:nil];
}

%new 
- (void)disableWiggle:(NSNotification *)notification 
{
    // This works even devices without a done button
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) 
    {
        [self doneButtonTriggered:self.contentView.doneButton];
    }
}

%end

%ctor {
    if (kCFCoreFoundationVersionNumber < 1600) %init;
}