//
//  AFLSerializationObject.m
//

#import "AFLSerializationObject.h"
#import "objc/runtime.h"

@implementation AFLSerializationObject

+ (NSDictionary*)propertyNamesConversion
{
    return nil;
}

- (void)setValuesWithDictionary:(NSDictionary*)dictionary
{
    NSDictionary* propertyNamesConversion = [[self class] propertyNamesConversion];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id dictObject, BOOL *stop)
     {
         NSString* convertedKey = [propertyNamesConversion objectForKey:key];
         if (!convertedKey) {
             convertedKey = key;
         }
         if (dictObject != nil && ![dictObject isKindOfClass:[NSNull class]])
         {
             id object = [self objectForJSONValue:dictObject forKey:key];
             if ([(NSNull*)object isEqual:[NSNull null]]) {
                 // Don't set value
             }
             else if (object) {
                 NSString *setterName = [NSString stringWithFormat:@"set%@%@:",
                                         [[convertedKey substringToIndex:1] capitalizedString],
                                         [convertedKey substringFromIndex:1]];
                 if ([self respondsToSelector:NSSelectorFromString(setterName)]) {
                     [self setValue:object forKey:convertedKey];
                 }
             }
             else {
                 NSString *setterName = [NSString stringWithFormat:@"set%@%@:",
                                        [[convertedKey substringToIndex:1] capitalizedString],
                                        [convertedKey substringFromIndex:1]];
                 if ([self respondsToSelector:NSSelectorFromString(setterName)]) {
                     [self setValue:dictObject forKey:convertedKey];
                 }
             }
         }
         
     }];
}

- (NSDictionary*)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *propertyNamesConversion = [[self class] propertyNamesConversion];
    NSSet *propertyList = [[self class] classPropsFor:[self class]];
    [propertyList enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
         __block NSString* convertedKey = nil;
         [propertyNamesConversion enumerateKeysAndObjectsUsingBlock:^(id conversionKey, id conversionObject, BOOL *conversionStop) {
             if ([conversionObject isEqual:obj]) {
                 convertedKey = conversionKey;
                 *conversionStop = YES;
             }
         }];
         if(!convertedKey){
             convertedKey = obj;
         }
         id propertyObject = [self valueForKey:obj];
         if (propertyObject != nil && ![propertyObject isKindOfClass:[NSNull class]])
         {
             id object = [self JSONValueForKey:obj];
             if ([(NSNull*)object isEqual:[NSNull null]])
             {
                 // Don't set value
             }
             else if (object) {
                 [dictionary setObject:object forKey:convertedKey];
             } else {
                 [dictionary setObject:propertyObject forKey:convertedKey];
             }
         }
    }];
    // strip id object with value 0;
    if ([dictionary objectForKey:@"id"]) {
        if ([[dictionary objectForKey:@"id"] intValue] == 0) {
            [dictionary removeObjectForKey:@"id"];
        }
    }
    return dictionary;
}

- (id)JSONValueForKey:(NSString*)key
{
    return nil;
}

- (id)objectForJSONValue:(id)value forKey:(NSString*)key
{
    return nil;
}

#pragma mark - properties from class
+ (NSSet *)classPropsFor:(Class)klass
{
    if (klass == NULL) {
        return nil;
    }
    
    NSMutableSet *results = [NSMutableSet set];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            [results addObject:[NSString stringWithUTF8String:propName]];
        }
    }
    free(properties);
    if ([klass superclass] && [[klass superclass] isSubclassOfClass:[AFLSerializationObject class]]) {
        [results addObjectsFromArray:[[AFLSerializationObject classPropsFor:[klass superclass]] allObjects]];
    }
    return (NSSet *)results;
}


@end