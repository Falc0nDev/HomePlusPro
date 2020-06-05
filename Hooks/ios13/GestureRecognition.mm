#include <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#include <UIKit/UIKit.h>
#include "HomePlus.h"
#include "HPEditorManager.h"
#include "HPManager.h"
#include "HPDataManager.h"
#include "HPExtensionManager.h"
#include "HPUtility.h"
#include <objc/runtime.h>
#define GetPref(key) CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef) key,(CFStringRef) @"me.kritanta.homeplusprefs"))

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

@interface UISystemGestureView : UIView
@property (nonatomic, retain) HPHitboxView *hp_hitbox;
@property (nonatomic, retain) HPHitboxWindow *hp_hitbox_window;
@property (nonatomic, retain) UIGestureRecognizer *hp_gesture;
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


#include <substrate.h>

@class UISystemGestureView; @class SBIconScrollView; 


static void _logos_method$PinchGesture$SBIconScrollView$homeplus_createPinchGesture( SBIconScrollView* , SEL); static void _logos_method$PinchGesture$SBIconScrollView$homeplus_activationListener$( SBIconScrollView* , SEL, NSNotification *); static void _logos_method$PinchGesture$SBIconScrollView$homeplus_handlePinchGesture$( SBIconScrollView* , SEL, UIPinchGestureRecognizer *); static void (*_logos_orig$PinchGesture$SBIconScrollView$layoutSubviews)( SBIconScrollView* , SEL); static void _logos_method$PinchGesture$SBIconScrollView$layoutSubviews( SBIconScrollView* , SEL); 



__attribute__((used)) static BOOL _logos_method$PinchGesture$SBIconScrollView$hitboxViewExists(SBIconScrollView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hitboxViewExists); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$PinchGesture$SBIconScrollView$setHitboxViewExists(SBIconScrollView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hitboxViewExists, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static BOOL _logos_method$PinchGesture$SBIconScrollView$editorOpened(SBIconScrollView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$editorOpened); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$PinchGesture$SBIconScrollView$setEditorOpened(SBIconScrollView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$editorOpened, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static BOOL _logos_method$PinchGesture$SBIconScrollView$editorActivated(SBIconScrollView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$editorActivated); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$PinchGesture$SBIconScrollView$setEditorActivated(SBIconScrollView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$editorActivated, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static CGFloat _logos_method$PinchGesture$SBIconScrollView$hpPanAmount(SBIconScrollView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hpPanAmount); CGFloat rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$PinchGesture$SBIconScrollView$setHpPanAmount(SBIconScrollView * __unused self, SEL __unused _cmd, CGFloat rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(CGFloat)]; objc_setAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hpPanAmount, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static BOOL _logos_method$PinchGesture$SBIconScrollView$hitboxMaxed(SBIconScrollView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hitboxMaxed); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$PinchGesture$SBIconScrollView$setHitboxMaxed(SBIconScrollView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hitboxMaxed, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

__attribute__((used)) static HPHitboxView * _logos_method$PinchGesture$SBIconScrollView$hp_hitbox(SBIconScrollView * __unused self, SEL __unused _cmd) { return (HPHitboxView *)objc_getAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hp_hitbox); }; __attribute__((used)) static void _logos_method$PinchGesture$SBIconScrollView$setHp_hitbox(SBIconScrollView * __unused self, SEL __unused _cmd, HPHitboxView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hp_hitbox, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static HPHitboxWindow * _logos_method$PinchGesture$SBIconScrollView$hp_hitbox_window(SBIconScrollView * __unused self, SEL __unused _cmd) { return (HPHitboxWindow *)objc_getAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hp_hitbox_window); }; __attribute__((used)) static void _logos_method$PinchGesture$SBIconScrollView$setHp_hitbox_window(SBIconScrollView * __unused self, SEL __unused _cmd, HPHitboxWindow * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hp_hitbox_window, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static HPHitboxView * _logos_method$PinchGesture$SBIconScrollView$hp_larger_hitbox(SBIconScrollView * __unused self, SEL __unused _cmd) { return (HPHitboxView *)objc_getAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hp_larger_hitbox); }; __attribute__((used)) static void _logos_method$PinchGesture$SBIconScrollView$setHp_larger_hitbox(SBIconScrollView * __unused self, SEL __unused _cmd, HPHitboxView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hp_larger_hitbox, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static HPHitboxWindow * _logos_method$PinchGesture$SBIconScrollView$hp_larger_window(SBIconScrollView * __unused self, SEL __unused _cmd) { return (HPHitboxWindow *)objc_getAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hp_larger_window); }; __attribute__((used)) static void _logos_method$PinchGesture$SBIconScrollView$setHp_larger_window(SBIconScrollView * __unused self, SEL __unused _cmd, HPHitboxWindow * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hp_larger_window, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static UIGestureRecognizer * _logos_method$PinchGesture$SBIconScrollView$hp_gesture(SBIconScrollView * __unused self, SEL __unused _cmd) { return (UIGestureRecognizer *)objc_getAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hp_gesture); }; __attribute__((used)) static void _logos_method$PinchGesture$SBIconScrollView$setHp_gesture(SBIconScrollView * __unused self, SEL __unused _cmd, UIGestureRecognizer * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$PinchGesture$SBIconScrollView$hp_gesture, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }



static void _logos_method$PinchGesture$SBIconScrollView$homeplus_createPinchGesture( SBIconScrollView*  __unused self, SEL __unused _cmd) {
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



static void _logos_method$PinchGesture$SBIconScrollView$homeplus_activationListener$( SBIconScrollView*  __unused self, SEL __unused _cmd, NSNotification * notification) {
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



static void _logos_method$PinchGesture$SBIconScrollView$homeplus_handlePinchGesture$( SBIconScrollView*  __unused self, SEL __unused _cmd, UIPinchGestureRecognizer * gestureRecognizer) {

    if (gestureRecognizer.scale > self.hpPanAmount && gestureRecognizer==self.hp_gesture)
        gestureRecognizer.scale = self.hpPanAmount;

    if (gestureRecognizer.scale < self.hpPanAmount && [HPManager sharedInstance]._rtGestureRecognizer.enabled )
    {
        
    }

    if (self.hp_gesture.state >= 1 && gestureRecognizer!=self.hp_gesture && gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;

    if ([HPManager sharedInstance]._rtGestureRecognizer.state >= 1 && gestureRecognizer==self.hp_gesture && gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;

    

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

            [HPManager sharedInstance]._rtGestureRecognizer.enabled = YES;
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


static void _logos_method$PinchGesture$SBIconScrollView$layoutSubviews( SBIconScrollView*  __unused self, SEL __unused _cmd) {
    _logos_orig$PinchGesture$SBIconScrollView$layoutSubviews(self, _cmd);

    if (!self.hp_gesture && ![HPManager sharedInstance]._pfGestureDisabled)
    {
        [self homeplus_createPinchGesture];
    }
}

static void _logos_method$DragDown$UISystemGestureView$createTopLeftHitboxView( UISystemGestureView* , SEL); static void _logos_method$DragDown$UISystemGestureView$recieveNotification$( UISystemGestureView* , SEL, NSNotification *); static void _logos_method$DragDown$UISystemGestureView$fader$( UISystemGestureView* , SEL, NSNotification *); static void _logos_method$DragDown$UISystemGestureView$move$( UISystemGestureView* , SEL, UIPanGestureRecognizer *); static void (*_logos_orig$DragDown$UISystemGestureView$layoutSubviews)( UISystemGestureView* , SEL); static void _logos_method$DragDown$UISystemGestureView$layoutSubviews( UISystemGestureView* , SEL); 

__attribute__((used)) static BOOL _logos_method$DragDown$UISystemGestureView$hitboxViewExists(UISystemGestureView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hitboxViewExists); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$DragDown$UISystemGestureView$setHitboxViewExists(UISystemGestureView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hitboxViewExists, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static BOOL _logos_method$DragDown$UISystemGestureView$editorOpened(UISystemGestureView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$editorOpened); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$DragDown$UISystemGestureView$setEditorOpened(UISystemGestureView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$editorOpened, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static BOOL _logos_method$DragDown$UISystemGestureView$editorActivated(UISystemGestureView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$editorActivated); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$DragDown$UISystemGestureView$setEditorActivated(UISystemGestureView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$editorActivated, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static HPHitboxView * _logos_method$DragDown$UISystemGestureView$hp_hitbox(UISystemGestureView * __unused self, SEL __unused _cmd) { return (HPHitboxView *)objc_getAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hp_hitbox); }; __attribute__((used)) static void _logos_method$DragDown$UISystemGestureView$setHp_hitbox(UISystemGestureView * __unused self, SEL __unused _cmd, HPHitboxView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hp_hitbox, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static HPHitboxWindow * _logos_method$DragDown$UISystemGestureView$hp_hitbox_window(UISystemGestureView * __unused self, SEL __unused _cmd) { return (HPHitboxWindow *)objc_getAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hp_hitbox_window); }; __attribute__((used)) static void _logos_method$DragDown$UISystemGestureView$setHp_hitbox_window(UISystemGestureView * __unused self, SEL __unused _cmd, HPHitboxWindow * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hp_hitbox_window, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static HPHitboxView * _logos_method$DragDown$UISystemGestureView$hp_larger_hitbox(UISystemGestureView * __unused self, SEL __unused _cmd) { return (HPHitboxView *)objc_getAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hp_larger_hitbox); }; __attribute__((used)) static void _logos_method$DragDown$UISystemGestureView$setHp_larger_hitbox(UISystemGestureView * __unused self, SEL __unused _cmd, HPHitboxView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hp_larger_hitbox, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static HPHitboxWindow * _logos_method$DragDown$UISystemGestureView$hp_larger_window(UISystemGestureView * __unused self, SEL __unused _cmd) { return (HPHitboxWindow *)objc_getAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hp_larger_window); }; __attribute__((used)) static void _logos_method$DragDown$UISystemGestureView$setHp_larger_window(UISystemGestureView * __unused self, SEL __unused _cmd, HPHitboxWindow * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hp_larger_window, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static CGFloat _logos_method$DragDown$UISystemGestureView$hpPanAmount(UISystemGestureView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hpPanAmount); CGFloat rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$DragDown$UISystemGestureView$setHpPanAmount(UISystemGestureView * __unused self, SEL __unused _cmd, CGFloat rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(CGFloat)]; objc_setAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hpPanAmount, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static BOOL _logos_method$DragDown$UISystemGestureView$hitboxMaxed(UISystemGestureView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hitboxMaxed); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$DragDown$UISystemGestureView$setHitboxMaxed(UISystemGestureView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$DragDown$UISystemGestureView$hitboxMaxed, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

static void _logos_method$DragDown$UISystemGestureView$createTopLeftHitboxView( UISystemGestureView*  __unused self, SEL __unused _cmd) {
    NSLog(@"HomePlus: %@", NSStringFromCGRect(self.frame));

    self.editorOpened = NO;
    self.hitboxMaxed = NO;
    self.hp_hitbox_window = [[HPHitboxWindow alloc] initWithFrame:CGRectMake(0, 0, ([HPUtility isCurrentDeviceNotched] ?120:80), ([HPUtility isCurrentDeviceNotched] ?40:20))];
    [HPManager sharedInstance]._rtHitboxWindow = self.hp_hitbox_window;
    self.hp_hitbox = [[HPHitboxView alloc] init];
    
    
    
    [self.hp_hitbox_window setValue:@NO forKey:@"deliversTouchesForGesturesToSuperview"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeDisabledNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fader:) name:kFadeFloatingDockNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fader:) name:kShowFloatingDockNotificationName object:nil];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    
    [self.hp_hitbox addGestureRecognizer:pan];


    CGFloat screenHeight = self.frame.size.height;
    CGFloat screenWidth = self.frame.size.width;


    self.hp_larger_window = [[HPHitboxWindow alloc] initWithFrame:CGRectMake( (0.15*screenWidth), (0.15*screenHeight), (0.7*screenWidth), (0.7*screenHeight))];
    self.hp_larger_hitbox = [[HPHitboxView alloc] init];
    self.hp_larger_hitbox.frame = CGRectMake(0,0, (0.7*screenWidth), (0.7*screenHeight));
    [self.hp_larger_window setValue:@NO forKey:@"deliversTouchesForGesturesToSuperview"];
    [self.hp_larger_window addSubview:self.hp_larger_hitbox];
    

    UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    
    [HPManager sharedInstance]._rtGestureRecognizer = pan2;
    CGSize hitboxSize = CGSizeMake( ([HPUtility isCurrentDeviceNotched] ?120:80), ([HPUtility isCurrentDeviceNotched] ?40:20));
    self.hp_hitbox.frame = CGRectMake(0, 0, hitboxSize.width, hitboxSize.height);
    [self.hp_hitbox_window addSubview:self.hp_hitbox];
    [self addSubview:self.hp_hitbox_window];

    self.hp_hitbox_window.hidden = NO;
    self.hp_hitbox_window.userInteractionEnabled = YES;
    self.hp_larger_window.userInteractionEnabled = NO;
    self.hp_larger_window.hidden = YES;
}



static void _logos_method$DragDown$UISystemGestureView$recieveNotification$( UISystemGestureView*  __unused self, SEL __unused _cmd, NSNotification * notification) {
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


static void _logos_method$DragDown$UISystemGestureView$fader$( UISystemGestureView*  __unused self, SEL __unused _cmd, NSNotification * notification) {
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

static void _logos_method$DragDown$UISystemGestureView$move$( UISystemGestureView*  __unused self, SEL __unused _cmd, UIPanGestureRecognizer * gestureRecognizer) {

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


static void _logos_method$DragDown$UISystemGestureView$layoutSubviews( UISystemGestureView*  __unused self, SEL __unused _cmd) {
    _logos_orig$DragDown$UISystemGestureView$layoutSubviews(self, _cmd);
    if (!self.hp_hitbox_window)
    {
        [self createTopLeftHitboxView];
    }
}





static __attribute__((constructor)) void _logosLocalCtor_71141b66(int __unused argc, char __unused **argv, char __unused **envp) {


    if (kCFCoreFoundationVersionNumber < 1600)
        return;

    Class _logos_class$PinchGesture$SBIconScrollView = objc_getClass("SBIconScrollView");
    { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(homeplus_createPinchGesture), (IMP)&_logos_method$PinchGesture$SBIconScrollView$homeplus_createPinchGesture, _typeEncoding); }
    { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSNotification *), strlen(@encode(NSNotification *))); i += strlen(@encode(NSNotification *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(homeplus_activationListener:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$homeplus_activationListener$, _typeEncoding); }
    { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIPinchGestureRecognizer *), strlen(@encode(UIPinchGestureRecognizer *))); i += strlen(@encode(UIPinchGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(homeplus_handlePinchGesture:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$homeplus_handlePinchGesture$, _typeEncoding); }
    MSHookMessageEx(_logos_class$PinchGesture$SBIconScrollView, @selector(layoutSubviews), (IMP)&_logos_method$PinchGesture$SBIconScrollView$layoutSubviews, (IMP*)&_logos_orig$PinchGesture$SBIconScrollView$layoutSubviews);{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL)); class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(hitboxViewExists), (IMP)&_logos_method$PinchGesture$SBIconScrollView$hitboxViewExists, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(setHitboxViewExists:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$setHitboxViewExists, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(editorOpened), (IMP)&_logos_method$PinchGesture$SBIconScrollView$editorOpened, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(setEditorOpened:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$setEditorOpened, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(editorActivated), (IMP)&_logos_method$PinchGesture$SBIconScrollView$editorActivated, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(setEditorActivated:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$setEditorActivated, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(CGFloat));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(hpPanAmount), (IMP)&_logos_method$PinchGesture$SBIconScrollView$hpPanAmount, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(CGFloat));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(setHpPanAmount:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$setHpPanAmount, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(hitboxMaxed), (IMP)&_logos_method$PinchGesture$SBIconScrollView$hitboxMaxed, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(setHitboxMaxed:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$setHitboxMaxed, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(HPHitboxView *));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(hp_hitbox), (IMP)&_logos_method$PinchGesture$SBIconScrollView$hp_hitbox, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(HPHitboxView *));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(setHp_hitbox:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$setHp_hitbox, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(HPHitboxWindow *));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(hp_hitbox_window), (IMP)&_logos_method$PinchGesture$SBIconScrollView$hp_hitbox_window, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(HPHitboxWindow *));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(setHp_hitbox_window:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$setHp_hitbox_window, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(HPHitboxView *));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(hp_larger_hitbox), (IMP)&_logos_method$PinchGesture$SBIconScrollView$hp_larger_hitbox, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(HPHitboxView *));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(setHp_larger_hitbox:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$setHp_larger_hitbox, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(HPHitboxWindow *));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(hp_larger_window), (IMP)&_logos_method$PinchGesture$SBIconScrollView$hp_larger_window, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(HPHitboxWindow *));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(setHp_larger_window:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$setHp_larger_window, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIGestureRecognizer *));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(hp_gesture), (IMP)&_logos_method$PinchGesture$SBIconScrollView$hp_gesture, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIGestureRecognizer *));
    class_addMethod(_logos_class$PinchGesture$SBIconScrollView, @selector(setHp_gesture:), (IMP)&_logos_method$PinchGesture$SBIconScrollView$setHp_gesture, _typeEncoding); } }

