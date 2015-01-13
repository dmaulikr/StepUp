//
//  NSManagedObject+TBAdditions.h
//

@import CoreData;

@interface NSManagedObject (TBAdditions)

/**
 *  Creates entity in context
 *
 *  @param entityName Entity name
 *  @param context    Context to create entity on
 *
 *  @return New entity
 */
+ (instancetype)createManagedObject:(NSString *)entityName inContext:(NSManagedObjectContext *)context;

/**
 *  Creates entity without a context
 *
 *  @param entityName Entity name
 *
 *  @return New entity not associated with a context
 */
+ (instancetype)createManagedObject:(NSString *)entityName;


/**
 *  Get or create entity, will try to fetch entity with field attributeName(core data entity property)
 *  which equal to attributeValue. Or create new enitity and set attributeName property with attributeValue
 *
 *  @param entityName     Entity to create
 *  @param attributeName  Name of attribute to search on
 *  @param attributeValue Value to search for in attribute name property
 *  @param context        Context to use for fetch request
 *
 *  @return New or existing entity
 */
+ (instancetype)getOrCreateManagedObject:(NSString *)entityName
                       withAttributeName:(NSString *)attributeName
                       andAttributeValue:(id)attributeValue
                        inManagedContext:(NSManagedObjectContext *)context;

/**
 *  Save changes to context
 *
 *  @param context   Context to save changes in
 *  @param error     Information about save error
 *
 */
- (BOOL)saveInManagedObjectContext:(NSManagedObjectContext *)context error:(NSError **)error;
@end
