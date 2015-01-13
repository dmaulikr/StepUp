#import "MindfulnessDagboek.h"
#import "TBCoreDataStore.h"

@interface MindfulnessDagboek ()

// Private interface goes here.

@end


@implementation MindfulnessDagboek

//+ (instancetype)createMindfulnessDagboek
//{
//    NSManagedObjectContext *context = [TBCoreDataStore mainQueueContext];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[MindfulnessDagboek entityName] inManagedObjectContext:context];
//    MindfulnessDagboek *newMindfulnessDagboek = [[MindfulnessDagboek alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
//    
//    return newMindfulnessDagboek;
//}

+ (instancetype)getMindfulnessDagboekForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day
{
    NSManagedObjectContext *context = [TBCoreDataStore mainQueueContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[MindfulnessDagboek entityName]];
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
//    __weak MindfulnessDagboek *weakSelf = self;
//    [context performBlock:^{
//        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[MindfulnessDagboek entityName]];
//        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"behandelingnummer = %@ AND dag = %@", weakSelf.behandelingnummer, weakSelf.dag];
//        
//        NSError *error;
//        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
//        if (!error) {
//            if ([result lastObject]) {
//                MindfulnessDagboek *md = [result lastObject];
//                md = weakSelf;
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
//
@end
