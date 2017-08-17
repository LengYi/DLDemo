//
//  NSURL+DLAdditions.h
//
//
//

#import <Foundation/Foundation.h>

@interface NSURL (DLAdditions)

// URL Encode
+ (NSURL *)encodeURLWithString:(NSString *)string;
+ (NSString *)decodedURLString:(NSString *)string;
+ (NSDictionary *)parseUrlParamers:(NSURL *)url;
@end
