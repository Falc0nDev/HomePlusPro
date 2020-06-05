#include <UIKit/UIKit.h>


#ifndef HPMONITOR_H
#define HPMONITOR_H

@interface HPMonitor : NSObject

+ (instancetype)sharedMonitor;

-(void)logItem:(NSString *)info;

@end

#endif