//
//  NSManagedObject+TBAdditions.m
//

#import "NSManagedObject+TBAdditions.h"

@implementation NSManagedObject (TBAdditions)

+ (instancetype)createManagedObject:(NSString *)entityName inContext:(NSManagedObjectContext *)context;
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
}

+ (instancetype)createManagedObject:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:nil];
}

+ (instancetype)getOrCreateManagedObject:(NSString *)entityName withAttributeName:(NSString *)attributeName andAttributeValue:(id)attributeValue inManagedContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K = %@",attributeName, attributeValue]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"%s ERROR: %@ %@", __PRETTY_FUNCTION__, [error localizedDescription], [error userInfo]);
        return nil;
    }
    
    id entity;
    if (results.count == 0)
    {
        entity = [[self class] createManagedObject:entityName inContext:context];
        [entity setValue:attributeValue forKey:attributeName];
    }
    else
    {
        entity = [results lastObject];
    }
    
    return entity;
}

- (BOOL)saveInManagedObjectContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    if ([context hasChanges]) {
        [context save:error];
    }
    if (error) {
        return NO;
    }
    return YES;
}

@end
