//
//  NSManagedObject+_NeedUpLoad_.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "NSManagedObject+_NeedUpLoad_.h"
#import "Project.h"
#import "Task.h"
#import "CaseInfo.h"
#import "UserInfo.h"
#import "CaseEnd.h"

#define NodeNameDefault @"现场勘验"
#define NodeIDDefault @"1"

@implementation NSManagedObject (_NeedUpLoad_)

+ (NSArray *)uploadArrayOfObject{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"isuploaded.boolValue == NO"]];
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (id)newDataObjectWithEntityName:(NSString *)entityName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    id obj = [[NSClassFromString(entityName) alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    if ([obj respondsToSelector:@selector(setMyid:)]) {
        [obj setValue:[NSString randomID] forKey:@"myid"];
    }
    if ([obj respondsToSelector:@selector(isuploaded)]) {
        [obj setValue:@(NO) forKey:@"isuploaded"];
    }
    if ([obj respondsToSelector:@selector(bad_type)]) {
        [obj setValue:@("") forKey:@"bad_type"];
    }
    if ([obj respondsToSelector:@selector(organization_id)]) {
        NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
        NSString *orgID = [UserInfo userInfoForUserID:currentUserID].organization_id;
        [obj setValue:orgID forKey:@"organization_id"];
    }
    if ([entityName isEqualToString:@"CaseInfo"]) {
        CaseInfo *caseInfo = (CaseInfo *)obj;
        Project *project = (Project *)[NSManagedObject newDataObjectWithEntityName:@"Project"];
        project.start_time = [NSDate date];
        project.inite_node_id = caseInfo.myid;
        project.process_id = ProcessIDDefault;
        project.process_name = ProcessNameDefault;
        NSLog(@"New Project: %@", project);
        Task *task = (Task *)[NSManagedObject newDataObjectWithEntityName:@"Task"];
        caseInfo.case_type_id = CaseTypeIDDefault;
        caseInfo.project_id = project.myid;
        task.myid = caseInfo.myid;
        task.node_name = NodeNameDefault;
        task.node_id = NodeIDDefault;
        task.project_id = project.myid;
        task.start_time = [NSDate date];
        [[AppDelegate App] saveContext];
    }
    else if ([entityName isEqualToString:@"CaseEnd"] || [entityName isEqualToString:@"CaseInvestigate"]){
        Task *task = (Task *)[NSManagedObject newDataObjectWithEntityName:@"Task"];
        task.myid = [obj valueForKey:@"myid"];
        
        // 这里逻辑比较乱，目前给Task.node_name 赋值， 是为了根据caseInfo.myid通过Task关联到node_name对应的model             \
           即 :                                                                                                     \
        caseinfo:案件表                                                                                              \
        project：项目表                                                                                              \
        task：项目节点表                                                                                              \
        一个案件就是一个项目，调查报告、结案报告是项目里面的一个节点，task表存的是节点的信息，该节点对应的业务数据存在对应的表中。      \
        所以CaseInvestigate\CaseEnd的id与其对应的Task的id是一样的,就像案件表的id也与其对应的task的id相等。                    \
        如果知道案件id，则项目id=(select project_id from Task where id=案件id)                                          \
        该案件调查报告的id=(select Id from Task where node_name='案件调查报告' and project_id =项目id)                    \
        该案件结案报告的id=(select Id from Task where node_name='结案报告' and project_id =项目id)
        
        task.node_name = NodeNameDictionary[entityName];
        task.node_id = NodeIDDefault;
        
        
        task.start_time = [NSDate date];
        [[AppDelegate App] saveContext];
    }
    return obj;
}

+ (NSString *)complexTypeString{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSDictionary *attributes = [entity attributesByName];
    NSString *typeString = @"";

    for (NSString *attriName in [attributes allKeys]) {
        if (![attriName isEqualToString:@"isuploaded"]) {
            NSAttributeDescription *attriDesc = [attributes objectForKey:attriName];
            NSString *elementString;
            switch (attriDesc.attributeType) {
                case NSDateAttributeType:
                    elementString = [[NSString alloc] initWithFormat:@"<xs:element name=\"%@\" type=\"xs:dateTime\" minOccurs=\"0\" />\r",attriName];
                    break;
                default:{
                    if ([attriName isEqualToString:@"myid"]) {
                        elementString = [[NSString alloc] initWithFormat:@"<xs:element name=\"id\" type=\"xs:string\" minOccurs=\"0\" />\r"];
                    } else if ([attriName isEqualToString:@"inspection_description"]){
                        elementString = [[NSString alloc] initWithFormat:@"<xs:element name=\"description\" type=\"xs:string\" minOccurs=\"0\" />\r"];
                    } else if ([attriName isEqualToString:@"map_item"]) {
                        elementString = [[NSString alloc] initWithFormat:@"<xs:element name=\"%@\" type=\"xs:string\" minOccurs=\"0\" />\r",attriName];
                        for (int i=1; i <= 9; i++) {
                            elementString = [elementString stringByAppendingFormat:@"<xs:element name=\"%@%d\" type=\"xs:string\" minOccurs=\"0\" />\r",attriName,i];
                        }
                    } else {
                        elementString = [[NSString alloc] initWithFormat:@"<xs:element name=\"%@\" type=\"xs:string\" minOccurs=\"0\" />\r",attriName];
                    }
                }
                    break;
            }
            typeString = [typeString stringByAppendingString:elementString];
        }
    }
    
    typeString = [[NSString alloc] initWithFormat:@"<xs:schema id=\"NewDataSet\" xmlns=\"\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:msdata=\"urn:schemas-microsoft-com:xml-msdata\">\r"
        "   <xs:element name=\"NewDataSet\" msdata:IsDataSet=\"true\" msdata:Locale=\"zh-CN\">\r"
        "       <xs:complexType>\r"
        "           <xs:choice maxOccurs=\"unbounded\">\r"
        "               <xs:element name=\"%@\">\r"
        "                   <xs:complexType>\r"
        "                       <xs:sequence>\r"
        "                           %@\r"
        "                       </xs:sequence>\r"
        "                   </xs:complexType>\r"
        "               </xs:element>\r"
        "           </xs:choice>\r"
        "       </xs:complexType>\r"
        "   </xs:element>\r"
        "</xs:schema>\r",NSStringFromClass([self class]),typeString];
    return typeString;
}

- (NSString *)dataXMLString{
    NSString *dataXMLString = @"";
    NSEntityDescription *entity=[self entity];
    NSDictionary *attributes = [entity attributesByName];
    for (NSString *attriName in [attributes allKeys]) {
        if (![attriName isEqualToString:@"isuploaded"]) {
            NSAttributeDescription *attriDesc = [attributes objectForKey:attriName];
            NSString *elementString = @"";
            id obj = [self valueForKey:attriName];
            switch (attriDesc.attributeType) {
                case NSStringAttributeType:{
                    if (obj == nil) {
                        obj = @"";
                    }
                    if (![attriName isEqualToString:@"maintainplan_id"]) {
                        if ([attriName isEqualToString:@"myid"]) {
                            elementString = [[NSString alloc] initWithFormat:@"<id>%@</id>\n",obj];
                        } else if ([attriName isEqualToString:@"inspection_description"]) {
                            elementString = [[NSString alloc] initWithFormat:@"<description>%@</description>\n",obj];
                        } else if ([attriName isEqualToString:@"map_item"]) {
                            elementString = [[NSString alloc] initWithFormat:@"<%@><![CDATA[%@]]></%@><map_item1></map_item1><map_item2></map_item2><map_item3></map_item3><map_item4></map_item4><map_item5></map_item5><map_item6></map_item6><map_item7></map_item7><map_item8></map_item8><map_item9></map_item9>",attriName,obj,attriName];
                        } else {
                            obj = [obj stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
                            elementString = [[NSString alloc] initWithFormat:@"<%@>%@</%@>\n",attriName,obj,attriName];
                        }
                    }
                }
                    break;
                case NSBooleanAttributeType:
                case NSFloatAttributeType:
                case NSDoubleAttributeType:
                case NSInteger16AttributeType:
                case NSInteger32AttributeType:
                case NSInteger64AttributeType:{
                    if (obj) {
                        elementString = [[NSString alloc] initWithFormat:@"<%@>%@</%@>\n",attriName,[obj stringValue],attriName];
                    } else {
                        elementString = [[NSString alloc] initWithFormat:@"<%@>0</%@>\n",attriName,attriName];
                    }
                }
                    break;
                case NSDateAttributeType:{
                    if (obj) {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                        [dateFormatter setLocale:[NSLocale currentLocale]];
                        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
                        [dateFormatter setTimeZone:timeZone];
                        elementString = [[NSString alloc] initWithFormat:@"<%@>%@</%@>\n",attriName,[dateFormatter stringFromDate:obj],attriName];
                    }
                }
                    break;
                default:
                    break;
            }
            if (![elementString isEmpty]) {
                dataXMLString = [dataXMLString stringByAppendingString:elementString];
            }
        }
    }
    if (![dataXMLString isEmpty]) {
        dataXMLString = [[NSString alloc] initWithFormat:@"<%@>%@</%@>",entity.name,dataXMLString,entity.name];
    }
    return dataXMLString;
}
@end
