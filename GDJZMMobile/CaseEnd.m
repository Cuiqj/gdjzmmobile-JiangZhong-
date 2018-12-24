//
//  CaseEnd.m
//  GDJZMMobile
//
//  Created by quxiuyun on 14-4-9.
//
//

#import "CaseEnd.h"
#import "Task.h"

@implementation CaseEnd

@dynamic myid;
@dynamic clerk;
@dynamic date_caseend;
@dynamic leader_name;
@dynamic date_underwrite;
@dynamic transact_decision;
@dynamic execute_circs;
@dynamic remark;
@dynamic isuploaded;


- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"proveinfo_id == %@", self.myid];
    }else{
        return @"";
    }
}


+ (NSArray *)CaseEndForCaseId:(NSString *)caseID{
    Task * task = [Task taskWithCaseId:caseID nodeName:NSStringFromClass([self class])];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid==%@",task.myid];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (id)newCaseEndWithCaseId:(NSString * )caseId
{
    CaseEnd * caseEndInfo =(CaseEnd *)[NSManagedObject newDataObjectWithEntityName:NSStringFromClass([self class])];
    Task *caseTask = [Task taskWithTaskId:caseId];
    Task *selfTask = [Task taskWithTaskId:caseEndInfo.myid];
    selfTask.project_id = caseTask.project_id;
    [[AppDelegate App] saveContext];
    return caseEndInfo;
}

@end
