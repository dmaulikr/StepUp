//
//  AFLSerializationObject.h
//

#import "AFLSerializationProtocol.h"

@interface AFLSerializationObject : NSObject <AFLSerializationProtocol>
/**
 Get a dictionary with class properties
 @param klass Classname to get the properties from
 @return NSDictionary with property names as a key and type as a value
 */
+ (NSSet *)classPropsFor:(Class)klass;

/**
 Set object properties based on json response
 @param dictionary The json response as a dictionary
 */
- (void)setValuesWithDictionary:(NSDictionary*)dictionary;

/**
 Creates dictionary representation from object based on it's properties
 @return Dictionary representation of the object
 */
- (NSDictionary*)dictionaryRepresentation;

/**
 Returns the json value of an object property for a given key.
 This way it is easy to translate object properties to the right json value
 @param key The key to translate an object property
 @return Object property translation for the given key
 */
- (id)JSONValueForKey:(NSString*)key;

/**
 Convert json value for given key to the right object.
 This way it is easy to translate json values to the right object property
 @param value The json value for given key
 @param key The json key to translate to an object property
 @return Object from value for key
 */
- (id)objectForJSONValue:(id)value forKey:(NSString*)key;
@end