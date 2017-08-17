//
//  NSObject+DataException.m
//
//
//

#import "NSObject+DataException.h"

@implementation NSObject (DataException)

+ (id)removeNull:(id)obj{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [self nullDic:obj];
    }else if([obj isKindOfClass:[NSArray class]]){
        return [self nullArr:obj];
    }else if ([obj isKindOfClass:[NSString class]]){
        return obj;
    }else if ([obj isKindOfClass:[NSNull class]]){
        return @"";
    }else return obj;
}

+ (id)nullDic:(NSDictionary *)dic{
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc] init];
    [resDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id newObj = [self removeNull:obj];
        [resDic setObject:newObj forKey:key];
    }];
    
    return resDic;
}

+ (id)nullArr:(NSArray *)arr{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id newObj = [self removeNull:obj];
        [resArr addObject:newObj];
    }];
    
    return resArr;
}


@end
