#import "_BewegenDagboek.h"
#import "NSManagedObject+TBAdditions.h"

@interface BewegenDagboek : _BewegenDagboek {}
+ (instancetype)getBewegenDagboekForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day;
@end
