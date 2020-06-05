#include "HomePlus.h"
#include "HomePlusEditor.h"

@interface SBIconListView (MainLayout13)
@property (nonatomic, assign) NSInteger iconsInRowForSpacingCalculation;
@property (nonatomic, assign) CGSize alignmentIconSize;
@property (nonatomic, assign) NSInteger firstFreeSlotIndex;
@property (nonatomic, retain) SBIconListFlowLayout *homeplus_layout;
- (NSUInteger)iconRowsForCurrentOrientation;
@end

@interface SBIconListFlowLayout (MainLayout)
- (void)homeplus_updateCachedConfiguration;
@property (nonatomic, retain) SBIconListGridLayoutConfiguration *homeplus_cachedConfiguration;
@property (nonatomic, retain) SBIconListGridLayoutConfiguration *homeplus_cachedDefault;
@end

%hook SBIconListView 

%property (nonatomic, assign) NSUInteger homeplus_pageIndex;
%property (nonatomic, retain) SBIconListFlowLayout *homeplus_layout;
%property (nonatomic, assign) BOOL configured;

- (id)initWithModel:(id)arg1 orientation:(id)arg2 viewMap:(id)arg3 
{
    id o = %orig(arg1, arg2, arg3);

    return o;
}

- (struct CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 metrics:(struct SBIconListLayoutMetrics)arg2
{
	CGPoint o = %orig(arg1, arg2);
    return o;
    //if ([HPManager sharedInstance]._rtIconViewInitialReloadCount < 2) return o;
    //if (GetLoadoutValue("Center", "Icons") ?: 0 != 1 && !([self.iconLocation containsString:@"Root"])) return o;
    
	struct SBIconCoordinate first;
	first.row = 1;
	first.col = 1;
    struct SBIconCoordinate second;
    second.row = 1;
    second.col = 2;

	NSInteger actualIndexForIcon = (arg1.row-1) * self.iconsInRowForSpacingCalculation + arg1.col - 1;
	NSInteger iconsInFinalRow = self.firstFreeSlotIndex % self.iconsInRowForSpacingCalculation; 
	NSInteger startingIndex = (self.firstFreeSlotIndex) - iconsInFinalRow;
	if (iconsInFinalRow == 0) return o;
    CGFloat iconWidth;
    iconWidth = self.alignmentIconSize.width;
    CGFloat left = (self.bounds.size.width - %orig(first, arg2).x * 2 - iconsInFinalRow * iconWidth - (iconsInFinalRow - 1) *
        (%orig(second, arg2).x - %orig(first, arg2).x - iconWidth)
    )/2;
    if(actualIndexForIcon >= startingIndex) 
        o.x = o.x + left;

    return o;

	//
	CGFloat iconSpacing =
	(
		self.frame.size.width-(
				%orig(first, arg2).x*2
				+
				self.subviews[0].bounds.size.width*self.iconsInRowForSpacingCalculation
			)
	)/(self.iconsInRowForSpacingCalculation-1);
	
	CGFloat iconOffsetAmount =
	(
		(
			self.frame.size.width
			- ( iconsInFinalRow * self.subviews[0].bounds.size.width )
			- ( iconsInFinalRow * iconSpacing )
			+ iconSpacing
		)
		/ 2
	)
	- (%orig(first, arg2)).x;

	if (actualIndexForIcon >= startingIndex)
	{
		o.x = o.x+iconOffsetAmount;
	}
	return o;
}

- (void)layoutSubviews 
{
    %orig;

    if (!self.configured) 
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(highlightView:) name:kHighlightViewNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutIconsNow) name:@"HPLayoutIconViews" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeplus_updateCache) name:@"HPUpdateLayoutCache" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutIconsNowWithAnimation) name:@"HPLayoutIconViewsAnimated" object:nil];
        self.configured = YES;
        [[[HPEditorManager sharedInstance] editorViewController] addRootIconListViewToUpdate:self];
        [HPManager sharedInstance]._rtConfigured = YES;
    }

    [self layoutIconsNow];
}

%new 
- (void)homeplus_updateCache 
{
    [[self layout] homeplus_updateCachedConfiguration];
}

%new 
- (void)layoutIconsNowWithAnimation
{
    [UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIconsNow];
    } completion:NULL];
}

- (BOOL)automaticallyAdjustsLayoutMetricsToFit
{
    return NO;
}

- (SBIconListModel* )model 
{
    SBIconListModel *model = %orig;

    model.homeplus_pageIndex = self.homeplus_pageIndex;
    model.homeplus_iconLocation = [self iconLocation];

    return model;
}

- (id)layout 
{
    SBIconListFlowLayout *layout = %orig;
    if (self.homeplus_layout)
        return self.homeplus_layout;
    //SBIconListFlowLayout *layout = [[%c(SBIconListFlowLayout) alloc] initWithLayoutConfiguration:[layout layoutConfiguration]];

    self.homeplus_layout = layout;

    self.homeplus_layout.homeplus_pageIndex = self.homeplus_pageIndex;
    self.homeplus_layout.homeplus_iconLocation = [[self iconLocation] substringFromIndex:14];

    
    return self.homeplus_layout;
}

%end

%group Dimensions

%hook SBIconListFlowLayout

- (NSUInteger)numberOfRowsForOrientation:(NSInteger)arg1
{
    NSInteger x = %orig(arg1);
    
    if ([HPManager sharedInstance]._tcDockyInstalled && x <=1) return %orig;

    if ([self.homeplus_iconLocation containsString:@"Folder"] || %orig == 3)
    {
        return %orig;
    }

    NSString *landscape = YES ? @"" : @"Landscape";

    if (YES)
    {
        if ([self.homeplus_iconLocation containsString:@"Root"])
        {
            self.homeplus_iconLocation = @"Root";
        }
    }

    if (self.homeplus_iconLocation == nil)
    {
        self.homeplus_iconLocation = @"Root";
    }

    return GetLoadoutValue(self.homeplus_iconLocation, @"Rows") ?: x;
}

- (NSUInteger)numberOfColumnsForOrientation:(NSInteger)arg1
{
    NSInteger x = %orig(arg1);

    [[self layoutConfiguration] portraitLayoutInsets];
    if ([self.homeplus_iconLocation containsString:@"Folder"] || %orig == 3)
    {
        return %orig;
    }

    if (![HPManager sharedInstance]._rtConfigured) return kMaxColumnAmount;

    NSString *landscape = YES ? @"" : @"Landscape";

    if (YES)
    {
        if ([self.homeplus_iconLocation containsString:@"Root"])
        {
            self.homeplus_iconLocation = @"Root";
        }
    }

    return GetLoadoutValue(self.homeplus_iconLocation, @"Columns")  ?:x;
}


%end



%end

%hook SBIconListFlowLayout

%property (nonatomic, assign) NSUInteger homeplus_pageIndex;
%property (nonatomic, retain) NSString *homeplus_iconLocation;
%property (nonatomic, retain) SBIconListGridLayoutConfiguration *homeplus_cachedConfiguration;
%property (nonatomic, retain) SBIconListGridLayoutConfiguration *homeplus_cachedDefault;

- (NSUInteger)maximumIconCount 
{
    NSString *x = [self homeplus_iconLocation];
    
    NSUInteger y = GetLoadoutValue(x, @"Columns") * GetLoadoutValue(x, @"Rows");
    return (y>0) ? y : %orig;
}
%new 
- (void)homeplus_updateCachedConfiguration
{
    if (!self.homeplus_cachedConfiguration)
        self.homeplus_cachedConfiguration = [[%c(SBIconListGridLayoutConfiguration) alloc] init];

    // cols

    if ((([HPManager sharedInstance]._tcDockyInstalled && ([self.homeplus_cachedDefault numberOfPortraitColumns] == 5 || [self.homeplus_cachedDefault numberOfPortraitColumns]==100)) // If Docky is changing the values (I wrote docky's latest version, I know what its going to give)
                          
                          || ([self.homeplus_iconLocation containsString:@"Folder"])
                          || ([self.homeplus_cachedDefault numberOfPortraitRows] == 1 && [self.homeplus_cachedDefault numberOfPortraitColumns]!=4) // or if another tweak is screwing with column values.
                                                                         // We only check here for dock values. I'm not making this compatible with HS layout tweaks, that's silly. 

                          || ([self.homeplus_iconLocation containsString:@"Dock"] 
                                && (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"]))))
    {
        [self.homeplus_cachedConfiguration setNumberOfPortraitColumns:[self.homeplus_cachedDefault numberOfPortraitColumns]];
    }

    [self.homeplus_cachedConfiguration setNumberOfPortraitColumns:GetLoadoutValue(self.homeplus_iconLocation, @"Columns") ?: [self.homeplus_cachedDefault numberOfPortraitColumns]];

    // rows
    if ((([HPManager sharedInstance]._tcDockyInstalled && ([self.homeplus_cachedDefault numberOfPortraitColumns]  == 5 || [self.homeplus_cachedDefault numberOfPortraitColumns] ==100)) // If Docky is changing the values (I wrote docky's latest version, I know what its going to give)
                          
                          || ([self.homeplus_iconLocation containsString:@"Folder"])
                          || ([self.homeplus_cachedDefault numberOfPortraitRows] == 1 && [self.homeplus_cachedDefault numberOfPortraitRows] !=4) // or if another tweak is screwing with column values.
                                                                         // We only check here for dock values. I'm not making this compatible with HS layout tweaks, that's silly. 

                          || ([self.homeplus_iconLocation containsString:@"Dock"] 
                                && (![[[HPDataManager sharedInstance] currentConfiguration] boolForKey:@"HPdockConfigEnabled"]))))
    {
        [self.homeplus_cachedConfiguration setNumberOfPortraitRows:[self.homeplus_cachedDefault numberOfPortraitRows]];
    }

    [self.homeplus_cachedConfiguration setNumberOfPortraitRows:GetLoadoutValue(self.homeplus_iconLocation, @"Rows") 
                    ?: [self.homeplus_cachedDefault numberOfPortraitRows]];
    
    UIEdgeInsets x = [self.homeplus_cachedDefault portraitLayoutInsets];
    UIEdgeInsets y;
    if ([self.homeplus_iconLocation containsString:@"Folder"])
    {
        y = [self.homeplus_cachedDefault portraitLayoutInsets];
    }
    else if ([self.homeplus_iconLocation isEqualToString:@"Dock"] && ([[[HPDataManager sharedInstance] currentConfiguration] integerForKey:@"HPdockConfigEnabled"]?:1) == 0)
        y = [self.homeplus_cachedDefault portraitLayoutInsets];

    else if ([self.homeplus_iconLocation isEqualToString:@"FloatingDockSuggestions"] || [self.homeplus_iconLocation isEqualToString:@"FloatingDock"])
    {
        y = UIEdgeInsetsMake(
            x.top + (GetLoadoutValue(@"Dock", @"TopInset")?:0),
            x.left,
            x.bottom - (GetLoadoutValue(@"Dock", @"TopInset")?:0), // * 2 because regularly it was too slow
            x.right
        );
    }

    else if ((!(GetLoadoutValue(self.homeplus_iconLocation, @"LeftInset")?:0)) == 0)
    {
        y = UIEdgeInsetsMake(
            x.top + (GetLoadoutValue(self.homeplus_iconLocation, @"TopInset")?:0),
            GetLoadoutValue(self.homeplus_iconLocation, @"LeftInset")?:0,
            x.bottom - (GetLoadoutValue(self.homeplus_iconLocation, @"TopInset")?:0) + (GetLoadoutValue(self.homeplus_iconLocation, @"VerticalSpacing")?:0) *-2, // * 2 because regularly it was too slow
            x.right - (GetLoadoutValue(self.homeplus_iconLocation, @"LeftInset")?:0) + (GetLoadoutValue(self.homeplus_iconLocation, @"SideInset")?:0) *-2
        );
    }
    else
    {
        y = UIEdgeInsetsMake(
            x.top + (GetLoadoutValue(self.homeplus_iconLocation, @"TopInset")?:0) ,
            x.left + (GetLoadoutValue(self.homeplus_iconLocation, @"SideInset")?:0)*-2,
            x.bottom - (GetLoadoutValue(self.homeplus_iconLocation, @"TopInset")?:0) + (GetLoadoutValue(self.homeplus_iconLocation, @"VerticalSpacing")?:0) *-2, // * 2 because regularly it was too slow
            x.right + (GetLoadoutValue(self.homeplus_iconLocation, @"SideInset")?:0)*-2
        );
    }
    [self.homeplus_cachedConfiguration setPortraitLayoutInsets:y];
}

- (id)layoutConfiguration
{

    if ([self.homeplus_iconLocation containsString:@"Folder"])
{
        return %orig;
}
    if (!self.homeplus_cachedDefault)
    {
        self.homeplus_cachedDefault = %orig;
    }
    if ([self.homeplus_iconLocation containsString:@"Root"])
    {
        self.homeplus_iconLocation = @"Root";
    }
    if (!self.homeplus_cachedConfiguration)
    {
        [self homeplus_updateCachedConfiguration];
    }
    return self.homeplus_cachedConfiguration;
}
- (UIEdgeInsets)layoutInsetsForOrientation:(NSInteger)arg1 
{
    return [self.homeplus_cachedConfiguration portraitLayoutInsets];
}

%end


%hook SBIconListModel 

%property (nonatomic, assign) NSUInteger homeplus_pageIndex;
%property (nonatomic, retain) NSString *homeplus_iconLocation;

// This is a read-only property, assigned on init
// For some odd reason, the ivar doesn't want us to modify it at all. 

// So, first we need to hook the selector
- (NSInteger)maxNumberOfIcons
{
    NSString *x = [[self homeplus_iconLocation] substringFromIndex:14];
    NSInteger rows =  GetLoadoutValue(x, @"Rows");
    if ([self.homeplus_iconLocation containsString:@"Dock"])
        rows++;
    NSUInteger y = GetLoadoutValue(x, @"Columns") * rows;
    return (y>0) ? y : %orig;
}

// This method uses the ivar that refuses to change
// So, we need to rewrite the entire method to properly use the selector we want to use,
//      instead of the ivars
- (NSUInteger)firstFreeSlotIndex
{
    if ([self numberOfIcons] >= [self maxNumberOfIcons])
        return 0x7FFFFFFFFFFFFFFFLL;

    return [self numberOfIcons];
}

// Same issue as last one, used ivars but we want it to use our selector instead
- (BOOL)isFullIncludingPlaceholders
{
    return ([[self icons] count] >= [self maxNumberOfIcons]);
}

%end



%hook SBRootFolderView 

// Quick hack to assign a page index to an SBIconListView. Always gets called. 
- (id)iconListViewAtIndex:(NSUInteger)index 
{
    SBIconListView *orig = %orig(index);

    orig.homeplus_pageIndex = index;

    return orig;
}

%end


%group Iconoclast 


%hook IconoclasmLayoutServer

+(CGFloat)topOffset
{
    return %orig + (GetLoadoutValue(@"Root", @"TopInset")?:0);
}

+(CGFloat)leftOffset
{
    return %orig + (GetLoadoutValue(@"Root", @"LeftInset")?:0);
}

%end


%end


%ctor 
{

    if (kCFCoreFoundationVersionNumber < 1600) return;

    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.kritanta.iconoclast.list"])
    {
        %init(Dimensions);
    }
    else 
    {
        dlopen("/Library/MobileSubstrate/DynamicLibraries/Iconoclasm.dylib", RTLD_NOW);
        %init(Iconoclast);
    }

    %init;
}

