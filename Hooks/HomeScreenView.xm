#include "HomePlusEditor.h"
#include "HomePlus.h"
%hook SBHomeScreenWindow

// Contains the Icon Lists
// Also where we inject the editor into springboard

- (id)_initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 rootViewController:(id)arg4 scene:(id)arg5
{
    id o = %orig(arg1, arg2, arg3, arg4, arg5);

    [HPManager sharedInstance].homeWindow = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeEnabledNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kEditingModeDisabledNotificationName object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kicker:) name:kEditorKickViewsUp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kicker:) name:kEditorKickViewsBack object:nil];

    // Create editor view and inject into springboard when this loads
    // Its in the perfect spot. Dont do this anywhere else 
    [self createManagers];

    return o;
}

%new 
- (void)kicker:(NSNotification *)notification
{
    return;
    CGAffineTransform transform = self.transform;

    [UIView animateWithDuration:0.4f// this matches it as closely as possible with the kicker in the editorviewcontroller
                                    // Maybe in the future I can find a way to animate them both at the same time. 
                                    // As for right now, I'm not quite sure :p
    animations:
    ^{
        // Why all this complex math? Why not CGAffineTransformIdentity?
        // We're shrinking the view 30% while all of this happens
        // So instead of using Identity, we basically verify its doing the right thing several times
        // This helps prevent bad notification calls, or pretty much anything else weird that might happen
        //      from making the view go off screen completely, requiring a reload 

        self.transform = (([[notification name] isEqualToString:kEditorKickViewsUp])                 // If we should move the view up
                        && ![HPManager sharedInstance]._rtKickedUp)                                                             //   And it isn't kicked up already (first verifiction)
                                ? CGAffineTransformTranslate(transform, 0, 
                                        (transform.ty == 0                                           //      If 0, move it up            (second verification)
                                            ? 0 - ([[UIScreen mainScreen] bounds].size.height * 0.7f) //      move up
                                            : 0.0f                                                   //      if its not 0, make it 0     (second v.)
                                        ))                                                           
                                : CGAffineTransformTranslate(transform, 0, 
                                        (transform.ty == 0                                           // If we should move it back 
                                            ? 0                                                      //   If it's 0, keep it as 0
                                            : ([[UIScreen mainScreen] bounds].size.height * 0.7f)     //     else, move it back.
                                        ));                                                          
    }]; 
}
%new
- (void)recieveNotification:(NSNotification *)notification
{
    BOOL enabled = ([[notification name] isEqualToString:kEditingModeEnabledNotificationName]);
    
    if (enabled) 
    {   
        BOOL x = [[%c(SBIconController) sharedInstance] _openFolderController] != nil;

        if (x) 
            [[HPEditorManager sharedInstance] setEditingLocation:@"SBIconLocationFolder"];
        else
        {
            [[HPEditorManager sharedInstance] setEditingLocation:@"SBIconLocationRoot"];
        }

        if ([[[HPEditorManager sharedInstance] editingLocation] isEqualToString:@"SBIconLocationRoot"] && NO)
        {
            [[HPEditorManager sharedInstance] setEditingLocation:@"SBIconLocationRootLandscape"];
        }
        else if ([[[HPEditorManager sharedInstance] editingLocation] isEqualToString:@"SBIconLocationRootLandscape"] && YES)
        {
            [[HPEditorManager sharedInstance] setEditingLocation:@"SBIconLocationRoot"];
        }

        if (@available(iOS 13.0, *)) 
        {
            if (kCFCoreFoundationVersionNumber > 1600) 
            {
                SBRootFolderController *controller = [[objc_getClass("SBIconController") sharedInstance] _rootFolderController];
                if ([controller isSidebarVisible] && [controller isSidebarEffectivelyVisible])
                {
                    if ([[[HPEditorManager sharedInstance] editingLocation] isEqualToString:@"SBIconLocationRoot"])
                    {
                        [[HPEditorManager sharedInstance] setEditingLocation:@"SBIconLocationRootWithSidebar"];
                    }
                    else if ([[[HPEditorManager sharedInstance] editingLocation] isEqualToString:@"SBIconLocationRootLandscape"])
                    {
                        [[HPEditorManager sharedInstance] setEditingLocation:@"SBIconLocationRootWithSidebarLandscape"];
                    }
                }
            }
        }
        [[HPDataManager sharedInstance].currentConfiguration loadConfigurationFromFile];
        [[[HPEditorManager sharedInstance] editorViewController] reload];
        [[HPEditorManager sharedInstance] showEditorView];
    }
    else
    {
        [[HPDataManager sharedInstance].currentConfiguration saveConfigurationToFile];
        [[HPEditorManager sharedInstance] hideEditorView];
    }
}

%new 
- (void)createManagers
{
    // Managers are created after the HomeScreen view is initialized
    // This makes sure the EditorView is *directly* above the HS view
    //      so, we can float things and obscure the view if needed.
    // It also lets the user use CC/NC/any of that fun stuff while editing

    if ([HPManager sharedInstance]._pfGestureDisabled)
    {
        return;
    }

    [HPExtensionManager sharedInstance];
    HPEditorWindow *view = [[HPEditorManager sharedInstance] editorView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];

    [HPManager sharedInstance];

    // This is commented out but needs to be implemented at some point
    //[self configureDefaultsIfNotYetConfigured];
    
}

%end