//
//  global.h
//  cloudMessage
//
//  Created by iMac mini on 2017/2/18.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#ifndef global_h
#define global_h

// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//设置颜色
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

#define RGBColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]



#endif /* global_h */
