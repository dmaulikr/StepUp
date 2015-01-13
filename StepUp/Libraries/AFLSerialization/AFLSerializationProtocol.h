//
//  AFLSerializationProtocol.h
//

#import <Foundation/Foundation.h>


@protocol AFLSerializationProtocol <NSObject>
/**
 Dictonary for mapping json keys to object properties, 
 this dictionary is used in JSONValueForKey:, objectForJSONValue:forKey:
 @return A dictionary with property mappings
 */
+(NSDictionary *)propertyNamesConversion;

@end