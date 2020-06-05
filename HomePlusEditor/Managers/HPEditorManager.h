//
// HPEditorManager.h
// HomePlus
//
// Global manager for the Editor (and tutorial) views. 
//
// Maybe at some point this should be refactored to HPEditorManager :)
//
// Authors: Kritanta
// Created  Oct 2019
//
#include <UIKit/UIKit.h>

#import "../EditorView/HPEditorViewController.h"
#import "../EditorView/HPEditorWindow.h"


#ifndef HPEDITORMANAGER_H
#define HPEDITORMANAGER_H

@interface HPEditorManager : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, retain) NSString *editingLocation;
@property (nonatomic, readonly, strong) HPEditorWindow *editorView;
@property (nonatomic, readonly, strong) HPEditorViewController *editorViewController;

@property (nonatomic, retain) UIImage *wallpaper;
@property (nonatomic, retain) UIImage *dynamicallyGeneratedSettingsHeaderImage;
@property (nonatomic, retain) UIImage *blurredAndDarkenedWallpaper;
@property (nonatomic, retain) UIImage *blurredMoreBackgroundImage;
-(UIImage *)bdBackgroundImage;
-(UIImage *)blurredMoreBGImage;
-(void)loadUpImagesFromWallpaper:(UIImage *)image;

-(HPEditorWindow *)editorView;
-(HPEditorViewController *)editorViewController;
-(void)resetAllValuesToDefaults;
-(void)showEditorView;
-(void)hideEditorView;

@end

#endif