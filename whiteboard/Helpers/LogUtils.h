//
//  LogUtils.h
//  whiteboard
//
//  Created by Stéphane Copin on 10/4/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <NSLogger/LoggerCommon.h>
#import <NSLogger/LoggerClient.h>

#ifdef DEBUG

#define LOG_NETWORK(level, ...)  LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"network",level,__VA_ARGS__)
#define LOG_GENERAL(level, ...)  LogMessageF(__FILE__,__LINE__,__FUNCTION__,[[NSString stringWithUTF8String:__FILE__] lastPathComponent],level,__VA_ARGS__)
#define LOG_GRAPHICS(level, ...) LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"graphics",level,__VA_ARGS__)
#define LOG_GRAPHICS(level, ...) LogImage(__FILE__,__LINE__,__FUNCTION__,@"graphics",level,__VA_ARGS__)

#else

#define LOG_NETWORK(...)  do {} while(0)
#define LOG_GENERAL(...)  do {} while(0)
#define LOG_GRAPHICS(...) do {} while(0)

#endif
