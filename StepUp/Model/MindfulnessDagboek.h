#import "_MindfulnessDagboek.h"
#import "NSManagedObject+TBAdditions.h"

@interface MindfulnessDagboek : _MindfulnessDagboek {}
//+ (instancetype)createMindfulnessDagboek;
+ (instancetype)getMindfulnessDagboekForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day;
//- (void)save;
@end
