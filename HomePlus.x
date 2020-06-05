//
// HomePlus.xm
// HomePlus
//
// Collection of the hooks needed to get this tweak working
//
// Pragma marks are formatted to look best in VSCode w/ mark jump
//
// Created Oct 2019
// Author: Kritanta
//

#include "HPEditorManager.h"
#include "HPExtensionManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPUtility.h"
#include "HomePlus.h"
#import <AudioToolbox/AudioToolbox.h>
#import <IconSupport/ISIconSupport.h>
#include <objc/runtime.h>
#include <dlfcn.h> 
#include <spawn.h>
#include "drm.h"

void setupGesture();

// Quick empty implementations for custom UIViews
// I use these solely to make things easier to find in Flex
//      and maybe they will come in useful later
@implementation HPTouchKillerHitboxView
@end

@implementation HPHitboxView
@end

@implementation HPHitboxWindow
@end

#pragma mark Global Values


// Global for the preference dict. Not used outside of reloadPrefs() but its cool to have
NSDictionary *prefs = nil;


static void *observer = NULL;

static void reloadPrefs() 
{
    if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) 
    {
        CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

        if (keyList) 
        {
            prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

            if (!prefs) 
            {
                prefs = [NSDictionary new];
            }
            CFRelease(keyList);
        }
    } 
    else 
    {
        prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
    }
}


@interface UIView (FixAllSubviewsCrash)
-(NSArray *)allSubviews;
@end

%hook UIView
%new
-(NSArray *)allSubviews {
        NSArray *subviews = [self subviews];
        NSMutableArray *allSubs = [subviews mutableCopy];

        for (UIView *subview in subviews) {
                [allSubs addObjectsFromArray: subview.allSubviews];
        }

        return (NSArray *)allSubs;
}
%end

static BOOL boolValueForKey(NSString *key, BOOL defaultValue) 
{
    return (prefs && [prefs objectForKey:key]) ? [[prefs objectForKey:key] boolValue] : defaultValue;
}

static BOOL pagebar = YES;

static void preferencesChanged() 
{
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();
    [HPManager sharedInstance]._pfTweakEnabled = boolValueForKey(@"HPEnabled", YES);
    [HPManager sharedInstance]._pfGestureDisabled = boolValueForKey(@"gesturedisabled", NO);
    pagebar = boolValueForKey(@"pagebar", YES);

    [HPManager sharedInstance]._pfActivationGesture = [[prefs valueForKey:@"gesture"] intValue];
    if (![HPManager sharedInstance]._rtIconSupportInjected && boolValueForKey(@"iconsupport", NO))
    {
        @try 
        {
            [HPManager sharedInstance]._rtIconSupportInjected = YES;
            dlopen("/Library/MobileSubstrate/DynamicLibraries/IconSupport.dylib", RTLD_NOW);
            [[objc_getClass("ISIconSupport") sharedInstance] addExtension:@"HomePlus"];
        }
        @catch (NSException *exception)
        {

        }
    }
}
#pragma mark ctor

%ctor
{
    //dlopen("/Library/Application Support/HomePlus.bundle/BLTNBoard.dylib", RTLD_NOW);

    preferencesChanged();

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        &observer,
        (CFNotificationCallback)preferencesChanged,
        (CFStringRef)@"me.kritanta.homeplus/settingschanged",
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );

    [HPDataManager sharedInstance];

    [HPManager sharedInstance]._tcDockyInstalled = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.docky.list"];

    if (pagebar)
{
        dlopen("/usr/lib/Pagebar.dylib", RTLD_NOW);
}

    //NSLog(@"HomePlus: %@",getudid());
}
