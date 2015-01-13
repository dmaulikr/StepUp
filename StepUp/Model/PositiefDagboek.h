#import "_PositiefDagboek.h"
#import "NSManagedObject+TBAdditions.h"

@interface PositiefDagboek : _PositiefDagboek {}
//+ (instancetype)createPositiefDagboek;
+ (instancetype)getPositiefDagboekForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day;
//- (void)save;
@end
