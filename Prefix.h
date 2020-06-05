#ifndef PREFIX
#define PREFIX
#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

// Macros for values we use
#define GetLoadoutValue(location, item) [[[HPDataManager sharedInstance] currentConfiguration] integerForKey:[NSString stringWithFormat:@"%@%@%@", @"HPData", location, item]]
#define kDeviceCornerRadius 39

// This is horrible and you should probably never use this ever.
#define fakeCopy(what) [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:what]]

#endif
