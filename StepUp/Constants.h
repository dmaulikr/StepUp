//
//  Constantd.h
//  StepUp
//
//  Created by Eelco Koelewijn on 10/09/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#ifndef StepUp_Constantd_h
#define StepUp_Constantd_h

    #define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
    #define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
    #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
    #define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
    #define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

    #define iOS7            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
    #define iOS8            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

#endif
