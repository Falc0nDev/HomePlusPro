//
// HPManager.m
// HomePlus
//
// Data Manager
//
// This class is kind of gutted from its former self
// Needs cleaned up for the stuff it handles now
//
// Created Oct 2019
// Author: Kritanta
//

#include "HPManager.h"

@implementation HPManager

+ (instancetype)sharedInstance
{
    static HPManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = (HPManager *)[[[self class] alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];

    if (self) {

        // Preference globals
        self._pfTweakEnabled = YES;
        // self._pfBatterySaver = NO; // Planned LPM Reduced Animation State
        self._pfGestureDisabled = YES;
        self._pfActivationGesture = 1;
        //static CGFloat _pfEditingScale = 0.7;

        // Values we use everywhere during runtime. 
        // These should be *avoided* wherever possible
        // We can likely interface managers to handle these without too much overhead
        self._rtEditingEnabled = NO;
        self._rtConfigured = NO;
        self._rtKickedUp = NO;
        self._rtIconSupportInjected = NO;
        // On <iOS 13 we need to reload the icon view initially several times to update our changes :)
        self._rtIconViewInitialReloadCount = 0;

        // Tweak compatability stuff. 
        // See the %ctor at the bottom of the file for more info
        self._tcDockyInstalled = NO;

        // Views to shrink with pan gesture
        self.wallpaperView = nil;
        self.homeWindow = nil;
        self.floatingDockWindow = nil;
        self.mockBackgroundView = nil;

        // Gesture recognizer to enable whenever kDisableEditingMode is hit.
        self._rtGestureRecognizer = nil;
        self._rtHitboxWindow = nil;
    }

    return self;
}

@end

