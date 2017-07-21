//
//  DLProtocolPackage.h
//
//  Created by ice on 17/2/10.
//  Copyright © 2017年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLProtocolPackage : NSObject

+ (NSData *)packageDataWithStringObjects:(id)firstObject,...;

+ (NSData *)packageDataWithDataArray:(NSArray *)array;
@end
