//
//  GICElementsCache.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/14.
//

#import "GICElementsCache.h"

@implementation GICElementsCache
// gloable elements
static NSMutableDictionary<NSString *,Class> *registedElementsMap = nil;
// behavior
static NSMutableDictionary<NSString *,Class> *registedBehaviorElementsMap = nil;
+(void)initialize{
    registedElementsMap = [NSMutableDictionary dictionary];
    registedBehaviorElementsMap = [NSMutableDictionary dictionary];
}

+(void)registElement:(Class)elementClass{
    if(class_getClassMethod(elementClass, @selector(gic_elementName))){
        NSString *name = [elementClass performSelector:@selector(gic_elementName)];
        if(name && [name length]>0){
            [registedElementsMap setValue:elementClass forKey:name];
            // 同事缓存属性
            [self registClassAttributs:elementClass];
        }
    }
}

+(Class)classForElementName:(NSString *)elementName{
    return [registedElementsMap objectForKey:elementName];
}





/**
 attributs 缓存
 
 @return <#return value description#>
 */
+ (NSMutableDictionary<NSString *,NSDictionary<NSString *,GICAttributeValueConverter *> *> *)classAttributsCache {
    static NSMutableDictionary *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NSMutableDictionary dictionary];
    });
    return _instance;
}


+(void)registClassAttributs:(Class)klass{
    if(!klass){
        return;
    }
    
    NSString *className = NSStringFromClass(klass);
    NSDictionary<NSString *,GICAttributeValueConverter *> *value = [self.classAttributsCache objectForKey:className];
    if (value) {//已经注册过了那么就忽略
        return;
    }
    
    if([className isEqualToString:@"GICGradientBackgroundInfo"]){
        
    }
    
    // 先给父类注册
    Class superClass = class_getSuperclass(klass);
    [self registClassAttributs:class_getSuperclass(klass)];
    
    NSMutableDictionary<NSString *, GICAttributeValueConverter *> *dict = [NSMutableDictionary dictionary];
    // 先添加父类的属性，再添加子类的属性。这样保证子类的属性可以覆盖父类的属性
    if(superClass){
        [dict addEntriesFromDictionary:[self.classAttributsCache objectForKey:NSStringFromClass(superClass)]];
    }
    [dict addEntriesFromDictionary:[klass performSelector:@selector(gic_elementAttributs)]];
    // 保存到缓存中
    [self.classAttributsCache setValue:dict forKey:className];
}

+(BOOL)injectAttributes:(NSDictionary<NSString *,GICAttributeValueConverter *> *)attributs forElementName:(NSString *)elementName{
    Class klass = [self classForElementName:elementName];
    if(!klass)
        return NO;
    NSMutableDictionary  *dict = (NSMutableDictionary *)[self classAttributs:klass];
    if(!dict){
        return NO;
    }
    [dict addEntriesFromDictionary:attributs];
    return true;
}

+(NSDictionary<NSString *, GICAttributeValueConverter *> *)classAttributs:(Class)klass{
    if(!klass){
        return nil;
    }
    NSString *className = NSStringFromClass(klass);
    if(![self.classAttributsCache.allKeys containsObject:className]){
        [self registClassAttributs:klass];
    }
    return [self.classAttributsCache objectForKey:className];
}

+(void)registBehaviorElement:(Class)elementClass{
    if(![elementClass isSubclassOfClass:[GICBehavior class]]){
        return;
    }
    if(class_getClassMethod(elementClass, @selector(gic_elementName))){
        NSString *name = [elementClass performSelector:@selector(gic_elementName)];
        if(name && [name length]>0){
            [registedBehaviorElementsMap setValue:elementClass forKey:name];
            // 同事缓存属性
            [self registClassAttributs:elementClass];
        }
    }
}

+(Class)classForBehaviorElementName:(NSString *)elementName{
    return [registedBehaviorElementsMap objectForKey:elementName];
}
@end
