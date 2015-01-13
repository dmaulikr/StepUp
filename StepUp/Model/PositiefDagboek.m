#import "PositiefDagboek.h"
#import "TBCoreDataStore.h"

@interface PositiefDagboek ()

// Private interface goes here.

@end


@implementation PositiefDagboek

//+ (instancetype)createPositiefDagboek
//{
//    NSManagedObjectContext *context = [TBCoreDataStore mainQueueContext];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[PositiefDagboek entityName] inManagedObjectContext:context];
//    PositiefDagboek *newPositiefDagboek = [[PositiefDagboek alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
//    
//    return newPositiefDagboek;
//}

+ (instancetype)getPositiefDagboekForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day
{
    NSManagedObjectContext *context = [TBCoreDataStore mainQueueContext];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[PositiefDagboek entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"behandelingnummer = %d AND dag = %@", weeknumber, day];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        if ([result lastObject]) {
            return [result lastObject];
        }
    }
    return nil;
}

//- (void)save
//{
//    NSManagedObjectContext *context = [TBCoreDataStore privateQueueContext];
//    __weak PositiefDagboek *weakSelf = self;
//    [context performBlock:^{
//        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[PositiefDagboek entityName]];
//        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"behandelingnummer = %@ AND dag = %@", weakSelf.behandelingnummer, weakSelf.dag];
//        
//        NSError *error;
//        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
//        if (!error) {
//            if ([result lastObject]) {
//                PositiefDagboek *pd = [result lastObject];
//                pd = weakSelf;
//            } else {
//                [context insertObject:weakSelf];
//            }
//            
//            [context save:nil];
//            
//        } else {
//            NSLog(@"error %s: %@",__PRETTY_FUNCTION__, error.localizedDescription);
//        }
//    }];
//}

@end
