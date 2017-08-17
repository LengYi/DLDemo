//
//  NSURL+AB_Additions.m
//
//
//

#import "NSURL+DLAdditions.h"

@implementation NSURL (DLAdditions)

+ (NSURL *)encodeURLWithString:(NSString *)string{
    NSURL *url = nil;
    CFStringRef originalString = (__bridge CFStringRef)string;
    CFStringRef charactersToLeaveUnescaped = NULL;
    CFStringRef legalURLCharactersToBeEscaped = (CFStringRef)@"!*'();@&=+$,#[]";
    CFStringEncoding encoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
    
    CFStringRef createString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, originalString, charactersToLeaveUnescaped, legalURLCharactersToBeEscaped, encoding);
    
    NSString *newString = (__bridge NSString *)createString;
    
    if (newString)
    {
        url = [NSURL URLWithString:newString];
        CFRelease(createString);
    }
    
	return url;
}

+ (NSString *)decodedURLString:(NSString *)string{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,                                                                                                                  (__bridge CFStringRef)string,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (NSDictionary *)parseUrlParamers:(NSURL *)url{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *parameterStr = [[url query] stringByRemovingPercentEncoding];
    NSArray *parameterArr = [parameterStr componentsSeparatedByString:@"&"];
    for (NSString *param in parameterArr) {
        NSArray *tmpArr = [param componentsSeparatedByString:@"="];
        if (tmpArr.count == 2) {
            [dict setObject:tmpArr[1] forKey:tmpArr[0]];
        }else{
            continue;
        }
    }
    return dict;
}

@end
