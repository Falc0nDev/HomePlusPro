#include "HomePlus.h"
%hook SBHomeScreenSpotlightViewController

- (id)initWithDelegate:(id)arg 
{
    id x = %orig(arg);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSearchView) name:kEditingModeEnabledNotificationName object:nil];
    return x;
}

%end

// Code here removed

%ctor {
if (kCFCoreFoundationVersionNumber > 1600) %init;
}