#include <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"
#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPExtensionManager.h"
#include "HPUtility.h"
#define GetPref(key) CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef) key,(CFStringRef) @"me.kritanta.homeplusprefs"))


static inline BOOL checkIsActivated()
{
    FILE *f = fopen( "/Library/MobileSubstrate/DynamicLibraries/HomePlus.dylib", "rb" );
    fseek(f, 905, 0);
    BOOL x = ((int)fgetc(f)!=0);
    fclose(f);
    return x;
}

@interface SBIconScrollView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, retain) HPHitboxView *hp_hitbox;
@property (nonatomic, retain) HPHitboxWindow *hp_hitbox_window;
@property (nonatomic, retain) UIGestureRecognizer *hp_gesture;

- (void)homeplus_createPinchGesture;
- (void)createFullScreenDragUpView;
- (void)_addGestureRecognizer:(id)arg atEnd:(BOOL)arg2;
@property (nonatomic, assign) CGFloat hpPanAmount;
@property (nonatomic, assign) BOOL editorOpened;
@property (nonatomic, assign) BOOL editorActivated;
@property (nonatomic, assign) BOOL hitboxMaxed;
@property (nonatomic, retain) HPHitboxView *hp_larger_hitbox;
@property (nonatomic, retain) HPHitboxWindow *hp_larger_window;

@end

@interface FBSystemGestureView (thing)
- (void)createTopLeftHitboxView;

- (void)homeplus_createPinchGesture;
- (void)createFullScreenDragUpView;
- (void)_addGestureRecognizer:(id)arg atEnd:(BOOL)arg2;
@property (nonatomic, assign) CGFloat hpPanAmount;
@property (nonatomic, assign) BOOL editorOpened;
@property (nonatomic, assign) BOOL editorActivated;
@property (nonatomic, assign) BOOL hitboxMaxed;
@property (nonatomic, retain) HPHitboxView *hp_larger_hitbox;
@property (nonatomic, retain) HPHitboxWindow *hp_larger_window;

@end

#define kMaxAmt 80

static CGFloat lastAmount = 1;

%group PinchGesture

%hook SBIconScrollView

%property (nonatomic, assign) BOOL hitboxViewExists;
%property (nonatomic, assign) BOOL editorOpened;
%property (nonatomic, assign) BOOL editorActivated;
%property (nonatomic, assign) CGFloat hpPanAmount;
%property (nonatomic, assign) BOOL hitboxMaxed;

%property (nonatomic, retain) HPHitboxView *hp_hitbox;
%property (nonatomic, retain) HPHitboxWindow *hp_hitbox_window;
%property (nonatomic, retain) HPHitboxView *hp_larger_hitbox;
%property (nonatomic, retain) HPHitboxWindow *hp_larger_window;
%property (nonatomic, retain) UIGestureRecognizer *hp_gesture;

%new
- (void)homeplus_createPinchGesture
{
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeplus_activationListener:) name:kEditingModeDisabledNotificationName object:nil];

UIPinchGestureRecognizer *pan = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(homeplus_handlePinchGesture:)];
UIPinchGestureRecognizer *pan2 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(homeplus_handlePinchGesture:)];

pan2.enabled = NO;
pan.delegate = self;
self.hp_gesture = pan;
self.hpPanAmount = 1;

[HPManager sharedInstance]._rtGestureRecognizer = pan2;
[self addGestureRecognizer:self.hp_gesture];
}

%new
- (void)homeplus_activationListener:(NSNotification *)notification
{
[HPManager sharedInstance].wallpaperView.transform = CGAffineTransformMakeScale(1, 1);
[HPManager sharedInstance].homeWindow.transform = CGAffineTransformMakeScale(1, 1);
[HPManager sharedInstance].floatingDockWindow.transform = CGAffineTransformMakeScale(1, 1);

[HPManager sharedInstance].homeWindow.layer.borderColor = [[UIColor clearColor] CGColor];
[HPManager sharedInstance].homeWindow.layer.borderWidth = 0;
[HPManager sharedInstance].homeWindow.layer.cornerRadius = 0;
[HPManager sharedInstance].wallpaperView.layer.cornerRadius = 0;

self.hitboxMaxed = NO;
self.hp_gesture.enabled = YES;
[HPManager sharedInstance]._rtGestureRecognizer.enabled = NO;
self.hp_larger_window.hidden = YES;


self.editorActivated = NO;
self.editorOpened = NO;
}

static int bean=0;

%new
- (void)homeplus_handlePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer
{

if (!bean)
{
FILE *f = fopen( "/Library/MobileSubstrate/DynamicLibraries/HomePlus.dylib", "rb" );
fseek(f, 905, 0);
if ((int)fgetc(f)!=254)
{
fclose(f);
@try {
[HPManager sharedInstance]._rtIconViewInitialReloadCount = 3;
[(SpringBoard*)[UIApplication sharedApplication] isShowingHomescreen];
}
@catch (NSException *ex){
return;
}
return;
}
else bean=1;
}


if (gestureRecognizer.scale > self.hpPanAmount && gestureRecognizer==self.hp_gesture)
gestureRecognizer.scale = self.hpPanAmount;

if (gestureRecognizer.scale < self.hpPanAmount && [HPManager sharedInstance]._rtGestureRecognizer.enabled )
{
//gestureRecognizer.scale = self.hpPanAmount;
}

if (self.hp_gesture.state >= 1 && gestureRecognizer!=self.hp_gesture && gestureRecognizer.state != UIGestureRecognizerStateEnded)
return;

if ([HPManager sharedInstance]._rtGestureRecognizer.state >= 1 && gestureRecognizer==self.hp_gesture && gestureRecognizer.state != UIGestureRecognizerStateEnded)
return;

//NSLog(@"HomeP: %f %f %@", (float)gestureRecognizer.scale, (float)gestureRecognizer.velocity, gestureRecognizer.description);

CGFloat maxAmt = 1;
CGFloat translation = 0;


if (gestureRecognizer.scale < 0.7)
gestureRecognizer.scale = 0.7;

CGFloat scalie = gestureRecognizer.scale;

if (gestureRecognizer.scale > 1 && gestureRecognizer != self.hp_gesture)
scalie *= ([HPManager sharedInstance]._rtGestureRecognizer.enabled ? .7 : 1);

if (scalie > 1)
scalie = 1;


translation = gestureRecognizer.scale;
self.hpPanAmount = scalie;

if (gestureRecognizer.scale < lastAmount && [HPManager sharedInstance]._rtGestureRecognizer.enabled && gestureRecognizer.state != UIGestureRecognizerStateEnded)
{
gestureRecognizer.scale = lastAmount;
return;
}
lastAmount = gestureRecognizer.scale;
if (gestureRecognizer.state == UIGestureRecognizerStateBegan && gestureRecognizer != [HPManager sharedInstance]._rtGestureRecognizer)
{
[[NSNotificationCenter defaultCenter] postNotificationName:kEditingModeEnabledNotificationName object:nil];
self.editorActivated = YES;
}

if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
{
if (self.hpPanAmount < 0)
self.hpPanAmount = 0;

if (self.hpPanAmount > maxAmt)
self.hpPanAmount = maxAmt;

if (!(self.hpPanAmount <= maxAmt * 0.90))
{
[[[HPEditorManager sharedInstance] editorViewController] transitionViewsToActivationPercentage:0 withDuration:0.15];
[UIView animateWithDuration:0.2
animations:^{
[HPManager sharedInstance].wallpaperView.transform = CGAffineTransformMakeScale(1,1);
[HPManager sharedInstance].homeWindow.transform = CGAffineTransformMakeScale(1,1);
[HPManager sharedInstance].floatingDockWindow.transform = CGAffineTransformMakeScale(1,1);
}
completion:^(BOOL finished)
{
[HPManager sharedInstance].homeWindow.layer.borderColor = [[UIColor clearColor] CGColor];
[HPManager sharedInstance].homeWindow.layer.borderWidth = 0;
[HPManager sharedInstance].homeWindow.layer.cornerRadius = 0;
[HPManager sharedInstance].wallpaperView.layer.cornerRadius = 0;
[HPManager sharedInstance]._rtGestureRecognizer.enabled = NO;

if (self.editorActivated)
{
[[NSNotificationCenter defaultCenter] postNotificationName:kEditingModeDisabledNotificationName object:nil];
AudioServicesPlaySystemSound(1519);
self.hp_gesture.enabled = YES;
self.editorActivated = NO;
self.editorOpened = NO;
}
}
];
}
else
{
[[[HPEditorManager sharedInstance] editorViewController] transitionViewsToActivationPercentage:1 withDuration:0.15];

[UIView animateWithDuration:0.2
animations:^{
CGAffineTransform restState = CGAffineTransformMakeScale(0.7,0.7);
restState.ty=-kMaxAmt;
[HPManager sharedInstance].wallpaperView.transform = restState;
[HPManager sharedInstance].homeWindow.transform = restState;
[HPManager sharedInstance].floatingDockWindow.transform = restState;
}
completion:^(BOOL finished)
{

self.editorOpened = YES;
[HPManager sharedInstance]._rtGestureRecognizer.enabled = YES;
self.hp_gesture.enabled = NO;
}
];
}
return;
}

if (self.hpPanAmount < 1)
{
if (!self.editorActivated)
{
[[NSNotificationCenter defaultCenter] postNotificationName:kEditingModeEnabledNotificationName object:nil];
self.editorActivated = YES;
}

[HPManager sharedInstance].homeWindow.layer.cornerRadius = [HPUtility isCurrentDeviceNotched] ? 35 : 0;
[HPManager sharedInstance].wallpaperView.layer.cornerRadius = [HPUtility isCurrentDeviceNotched] ? 35 : 0;
[HPManager sharedInstance].homeWindow.layer.cornerCurve = kCACornerCurveContinuous;
[HPManager sharedInstance].wallpaperView.layer.cornerCurve = kCACornerCurveContinuous;
}
else
{
[HPManager sharedInstance].homeWindow.layer.cornerRadius = 0;
[HPManager sharedInstance].wallpaperView.layer.cornerRadius = 0;
}

if (self.hpPanAmount >= maxAmt)
{
if (!self.hitboxMaxed)
{
self.hitboxMaxed = YES;
self.hp_hitbox_window.userInteractionEnabled = NO;
self.hp_larger_window.userInteractionEnabled = YES;
self.hp_larger_window.hidden = NO;
}

if (self.editorOpened)
self.hpPanAmount = maxAmt;
else
{
self.hpPanAmount = maxAmt;

self.editorOpened = YES;
AudioServicesPlaySystemSound(1519);
}
}


CGAffineTransform movement = CGAffineTransformMakeScale(scalie, scalie);
// .85 = 0.0
// .80 = 0.33
// .75 = 0.66
// .7  = 1.0
// x = scale
// y = outcome
// .85 - .85 = 0
// .85 - .7 = .15
// (.85 - x)*(60/9)
//

CGFloat bump = scalie > 0.85 ? 0 : (.85-scalie)*(6.66666666666666666)*(-kMaxAmt)*1.42;
NSLog(@"HomeP: bump %f %f", (float)bump, (float)scalie);
movement = CGAffineTransformTranslate(movement,0,bump);

[HPManager sharedInstance].wallpaperView.transform = movement;
[HPManager sharedInstance].homeWindow.transform = movement;
[HPManager sharedInstance].floatingDockWindow.transform = movement;

CGFloat pctgOfTotal = ((((.15*[UIScreen mainScreen].bounds.size.height) - [HPManager sharedInstance].homeWindow.frame.origin.y)+ [HPManager sharedInstance].homeWindow.frame.size.height)  ) / [UIScreen mainScreen].bounds.size.height;
pctgOfTotal = 1-pctgOfTotal;
pctgOfTotal *= 5;
[[[HPEditorManager sharedInstance] editorViewController] transitionViewsToActivationPercentage:pctgOfTotal];

}

- (void)layoutSubviews
{
%orig;

if (!self.hp_gesture && ![HPManager sharedInstance]._pfGestureDisabled)
{
[self homeplus_createPinchGesture];
}
}

%end

%end

%group DragDown

%hook FBSystemGestureView

//
// iOS 13 view we inject our gesture recognizer into
// This *regularly* gets copy pasted over FBGestureView
// You will notice the same comments in both places
// That is why.
//

%property (nonatomic, assign) BOOL hitboxViewExists;
%property (nonatomic, assign) BOOL editorOpened;
%property (nonatomic, assign) BOOL editorActivated;
%property (nonatomic, retain) HPHitboxView *hp_hitbox;
%property (nonatomic, retain) HPHitboxWindow *hp_hitbox_window;
%property (nonatomic, retain) HPHitboxView *hp_larger_hitbox;
%property (nonatomic, retain) HPHitboxWindow *hp_larger_window;
%property (nonatomic, assign) CGFloat hpPanAmount;
%property (nonatomic, assign) BOOL hitboxMaxed;

%new
- (void)createTopLeftHitboxView
{
NSLog(@"HomePlus: %@", NSStringFromCGRect(self.frame));

self.editorOpened = NO;
self.hitboxMaxed = NO;
self.hp_hitbox_window = [[HPHitboxWindow alloc] initWithFrame:CGRectMake(0, 0, ([HPUtility isCurrentDeviceNotched] ?120:80), ([HPUtility isCurrentDeviceNotched] ?40:20))];
[HPManager sharedInstance]._rtHitboxWindow = self.hp_hitbox_window;
self.hp_hitbox = [[HPHitboxView alloc] init];
// This is useful for debugging hitbox locations on weird devices
//self.hp_hitbox.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.5];
//self.hp_hitbox_window.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.5];
[self.hp_hitbox_window setValue:@NO forKey:@"deliversTouchesForGesturesToSuperview"];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeDisabledNotificationName object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fader:) name:kFadeFloatingDockNotificationName object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fader:) name:kShowFloatingDockNotificationName object:nil];
UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
// = pan;
[self.hp_hitbox addGestureRecognizer:pan];


CGFloat screenHeight = self.frame.size.height;
CGFloat screenWidth = self.frame.size.width;


self.hp_larger_window = [[HPHitboxWindow alloc] initWithFrame:CGRectMake( (0.15*screenWidth), (0.15*screenHeight), (0.7*screenWidth), (0.7*screenHeight))];
self.hp_larger_hitbox = [[HPHitboxView alloc] init];
self.hp_larger_hitbox.frame = CGRectMake(0,0, (0.7*screenWidth), (0.7*screenHeight));
[self.hp_larger_window setValue:@NO forKey:@"deliversTouchesForGesturesToSuperview"];
[self.hp_larger_window addSubview:self.hp_larger_hitbox];
//[self addSubview:self.hp_larger_window];

UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
//[self.hp_larger_hitbox addGestureRecognizer:pan2];
[HPManager sharedInstance]._rtGestureRecognizer = pan2;
CGSize hitboxSize = CGSizeMake( ([HPUtility isCurrentDeviceNotched] ?120:80), ([HPUtility isCurrentDeviceNotched] ?40:20));
self.hp_hitbox.frame = CGRectMake(0, 0, hitboxSize.width, hitboxSize.height);
[self.hp_hitbox_window addSubview:self.hp_hitbox];
[self addSubview:self.hp_hitbox_window];


//self.hp_larger_hitbox.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.5];
//self.hp_larger_window.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.5];

self.hp_hitbox_window.hidden = NO;
self.hp_hitbox_window.userInteractionEnabled = YES;
self.hp_larger_window.userInteractionEnabled = NO;
self.hp_larger_window.hidden = YES;
}

%new
-(void)recieveNotification:(NSNotification *)notification
{
[HPManager sharedInstance].wallpaperView.transform = CGAffineTransformMakeScale(1, 1);
[HPManager sharedInstance].homeWindow.transform = CGAffineTransformMakeScale(1, 1);
[HPManager sharedInstance].floatingDockWindow.transform = CGAffineTransformMakeScale(1, 1);
[HPManager sharedInstance].homeWindow.layer.borderColor = [[UIColor clearColor] CGColor];
[HPManager sharedInstance].homeWindow.layer.borderWidth = 0;
[HPManager sharedInstance].homeWindow.layer.cornerRadius = 0;
[HPManager sharedInstance].wallpaperView.layer.cornerRadius = 0;
if (self.hitboxMaxed)
{
self.hitboxMaxed = NO;
self.hp_hitbox_window.userInteractionEnabled = YES;
self.hp_larger_window.userInteractionEnabled = NO;
self.hp_larger_window.hidden = YES;
}
self.editorActivated = NO;
self.editorOpened = NO;
}
%new
-(void)fader:(NSNotification *)notification
{
if ([[notification name] isEqualToString:kFadeFloatingDockNotificationName])
{
self.hp_larger_window.hidden = YES;
[self.hp_larger_window setValue:@YES forKey:@"deliversTouchesForGesturesToSuperview"];
}
else
{
self.hp_larger_window.hidden = NO;
[self.hp_larger_window setValue:@NO forKey:@"deliversTouchesForGesturesToSuperview"];
}
}
%new
-(void)move:(UIPanGestureRecognizer *)gestureRecognizer
{

//NSLog(@"HomePlus: %f %f %@", (float)gestureRecognizer.scale, (float)gestureRecognizer.velocity, gestureRecognizer.description);

NSLog(@"HomePlus: %f ", (float)[gestureRecognizer translationInView:self].y);
CGFloat maxAmt = UIScreen.mainScreen.bounds.size.height * .15;
CGFloat translation = 0;

CGFloat fakeScale = 1 - (([gestureRecognizer translationInView:self].y / maxAmt) * 0.3);

if ([gestureRecognizer translationInView:self].y < 0 )
{
fakeScale -= .3;
}
NSLog(@"HomePlus: f%f ", fakeScale);
if (fakeScale < 0.7)
fakeScale = 0.7;

CGFloat scalie = fakeScale;

if (scalie > 1)
scalie = 1;


translation = fakeScale;
self.hpPanAmount = scalie;

lastAmount = fakeScale;
if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
{
[[NSNotificationCenter defaultCenter] postNotificationName:kEditingModeEnabledNotificationName object:nil];
self.editorActivated = YES;
}

if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
{
if (self.hpPanAmount < 0)
self.hpPanAmount = 0;

if (self.hpPanAmount > maxAmt)
self.hpPanAmount = maxAmt;

if (self.hpPanAmount >= 0.90)
{
[[[HPEditorManager sharedInstance] editorViewController] transitionViewsToActivationPercentage:0 withDuration:0.15];
[UIView animateWithDuration:0.2
animations:^{
[HPManager sharedInstance].wallpaperView.transform = CGAffineTransformMakeScale(1,1);
[HPManager sharedInstance].homeWindow.transform = CGAffineTransformMakeScale(1,1);
[HPManager sharedInstance].floatingDockWindow.transform = CGAffineTransformMakeScale(1,1);
}
completion:^(BOOL finished)
{
[HPManager sharedInstance].homeWindow.layer.borderColor = [[UIColor clearColor] CGColor];
[HPManager sharedInstance].homeWindow.layer.borderWidth = 0;
[HPManager sharedInstance].homeWindow.layer.cornerRadius = 0;
[HPManager sharedInstance].wallpaperView.layer.cornerRadius = 0;
[HPManager sharedInstance]._rtGestureRecognizer.enabled = NO;

if (self.editorActivated)
{
[[NSNotificationCenter defaultCenter] postNotificationName:kEditingModeDisabledNotificationName object:nil];
AudioServicesPlaySystemSound(1519);
self.editorActivated = NO;
self.editorOpened = NO;
}
}
];
}
else
{
[[[HPEditorManager sharedInstance] editorViewController] transitionViewsToActivationPercentage:1 withDuration:0.15];

[UIView animateWithDuration:0.2
animations:^{
CGAffineTransform restState = CGAffineTransformMakeScale(0.7,0.7);
restState.ty=-kMaxAmt;
[HPManager sharedInstance].wallpaperView.transform = restState;
[HPManager sharedInstance].homeWindow.transform = restState;
[HPManager sharedInstance].floatingDockWindow.transform = restState;
}
completion:^(BOOL finished)
{

self.editorOpened = YES;
}
];
}
return;
}

if (self.hpPanAmount < 1)
{
if (!self.editorActivated)
{
[[NSNotificationCenter defaultCenter] postNotificationName:kEditingModeEnabledNotificationName object:nil];
self.editorActivated = YES;
}

[HPManager sharedInstance].homeWindow.layer.cornerRadius = [HPUtility isCurrentDeviceNotched] ? 35 : 0;
[HPManager sharedInstance].wallpaperView.layer.cornerRadius = [HPUtility isCurrentDeviceNotched] ? 35 : 0;
[HPManager sharedInstance].homeWindow.layer.cornerCurve = kCACornerCurveContinuous;
[HPManager sharedInstance].wallpaperView.layer.cornerCurve = kCACornerCurveContinuous;
}
else
{
[HPManager sharedInstance].homeWindow.layer.cornerRadius = 0;
[HPManager sharedInstance].wallpaperView.layer.cornerRadius = 0;
}

if (self.hpPanAmount >= maxAmt)
{
if (!self.hitboxMaxed)
{
self.hitboxMaxed = YES;
self.hp_hitbox_window.userInteractionEnabled = NO;
self.hp_larger_window.userInteractionEnabled = YES;
self.hp_larger_window.hidden = NO;
}

if (self.editorOpened)
self.hpPanAmount = maxAmt;
else
{
self.hpPanAmount = maxAmt;

self.editorOpened = YES;
AudioServicesPlaySystemSound(1519);
}
}


CGAffineTransform movement = CGAffineTransformMakeScale(scalie, scalie);
// .85 = 0.0
// .80 = 0.33
// .75 = 0.66
// .7  = 1.0
// x = scale
// y = outcome
// .85 - .85 = 0
// .85 - .7 = .15
// (.85 - x)*(60/9)
//

CGFloat bump = scalie > 0.85 ? 0 : (.85-scalie)*(6.66666666666666666)*(-kMaxAmt)*1.42;
NSLog(@"HomeP: bump %f %f", (float)bump, (float)scalie);
movement = CGAffineTransformTranslate(movement,0,bump);

[HPManager sharedInstance].wallpaperView.transform = movement;
[HPManager sharedInstance].homeWindow.transform = movement;
[HPManager sharedInstance].floatingDockWindow.transform = movement;

CGFloat pctgOfTotal = ((((.15*[UIScreen mainScreen].bounds.size.height) - [HPManager sharedInstance].homeWindow.frame.origin.y)+ [HPManager sharedInstance].homeWindow.frame.size.height)  ) / [UIScreen mainScreen].bounds.size.height;
pctgOfTotal = 1-pctgOfTotal;
pctgOfTotal *= 5;
[[[HPEditorManager sharedInstance] editorViewController] transitionViewsToActivationPercentage:pctgOfTotal];

}

- (void)layoutSubviews
{
%orig;
if (!self.hp_hitbox_window)
{
[self createTopLeftHitboxView];
}
}

%end

%end

%ctor {


if (kCFCoreFoundationVersionNumber > 1600) return;

if ([HPManager sharedInstance]._pfActivationGesture == 1)
%init(PinchGesture);
else
%init(DragDown);
}