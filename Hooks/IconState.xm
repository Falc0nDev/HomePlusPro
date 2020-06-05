#include "HPDataManager.h"

#define KEY @"HPModifiedIconState"

%hook SBDefaultIconModelStore
/*
-(id)loadCurrentIconState:(id*)error
{
    HPConfiguration *defaults = [[HPDataManager sharedInstance] currentConfiguration];
    if ([defaults objectForKey:KEY]) {
        return [defaults objectForKey:KEY];
    }

    id orig = %orig;
    [defaults setObject:orig forKey:KEY];
    return orig;
}

-(BOOL)saveCurrentIconState:(id)state error:(id*)error
{
    HPConfiguration *defaults = [[HPDataManager sharedInstance] currentConfiguration];
    [defaults setObject:state forKey:KEY];
    return %orig;
}*/

%end