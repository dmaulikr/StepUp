#import "BewegenDagboek.h"
#import "TBCoreDataStore.h"

@interface BewegenDagboek ()

// Private interface goes here.

@end


@implementation BewegenDagboek

//////TODO: add get or create
//
//+ (instancetype)createBewegenDagboek
//{
//    NSManagedObjectContext *context = [TBCoreDataStore mainQueueContext];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[BewegenDagboek entityName] inManagedObjectContext:context];
//    BewegenDagboek *newBewegenDagboek = [[BewegenDagboek alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
//    
//    return newBewegenDagboek;
//}

+ (instancetype)getBewegenDagboekForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day
{
    NSManagedObjectContext *context = [TBCoreDataStore mainQueueContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[BewegenDagboek entityName]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"behandelingnummer = %d AND dag = %@", weeknumber, day];
    fetchRequest.predicate = predicate;
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        if ([result lastObject]) {
            return [result lastObject];
        }
    }
    return nil;
}


//////TODO: update save only check
//////TODO: copy coredata from wereldhave project
//- (void)save
//{
//    NSManagedObjectContext *context = [TBCoreDataStore privateQueueContext];
//
//    [context performBlock:^{
//        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[BewegenDagboek entityName]];
//        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"behandelingnummer = %@ AND dag = %@", self.behandelingnummer, self.dag];
//        
//        NSError *error;
//        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
//        if (!error) {
//            if ([result lastObject]) {
//                BewegenDagboek *bd = [result lastObject];
//                bd = self;
//            } else {
//                [context insertObject:self];
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
