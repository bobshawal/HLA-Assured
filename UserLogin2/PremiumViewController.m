//
//  PremiumViewController.m
//  HLA
//
//  Created by shawal sapuan on 9/11/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PremiumViewController.h"

@interface PremiumViewController ()

@end

@implementation PremiumViewController
@synthesize WebView;
@synthesize requestBasicSA,requestBasicHL,requestMOP,requestTerm,requestPlanCode,requestSINo,requestAge;
@synthesize basicRate,basicLSDRate,riderCode,riderSA,riderHL1K,riderHL100,riderHLP,riderRate,riderLSDRate,riderTerm;
@synthesize riderDesc,planCodeRider,riderUnit,riderPlanOpt,riderDeduct,pentaSQL;
@synthesize plnOptC,planOptHMM,deducHMM,planHSPII,planMGII,planMGIV;
@synthesize riderAge,riderCustCode,riderSmoker;
@synthesize annualRiderTot,halfRiderTot,quarterRiderTot,monthRiderTot;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    NSLog(@"tbPrem - MOP:%d, term:%d, sa:%@, hl:%@",requestMOP,requestTerm,requestBasicSA,requestBasicHL);
    
    [self checkExistRider];
    if ([riderCode count] != 0) {
        NSLog(@"rider exist!");
        [self calculateRiderPrem];
    } else {
        NSLog(@"rider not exist!");
    }
    
    [self calculatePremium];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)doClose:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Calculation

-(void)calculatePremium
{
    [self getBasicPentaRate];
    [self getBasicLSDRate];
    
    //calculate basic premium
    double BasicSA = [[self.requestBasicSA description] doubleValue];
    double BasicAnnually = basicRate * (BasicSA/1000) * 1;
    double BasicHalfYear = basicRate * (BasicSA/1000) * 0.5125;
    double BasicQuarterly = basicRate * (BasicSA/1000) * 0.2625;
    double BasicMonthly = basicRate * (BasicSA/1000) * 0.0875;
    NSLog(@"Basic A:%.3f, S:%.3f, Q:%.3f, M:%.3f",BasicAnnually,BasicHalfYear,BasicQuarterly,BasicQuarterly);
    
    //calculate basic health loading
    double BasicHLoad = [[self.requestBasicHL description] doubleValue];
    double BasicHLAnnually = BasicHLoad * (BasicSA/1000) * 1;
    double BasicHLHalfYear = BasicHLoad * (BasicSA/1000) * 0.5125;
    double BasicHLQuarterly = BasicHLoad * (BasicSA/1000) * 0.2625;
    double BasicHLMonthly = BasicHLoad * (BasicSA/1000) * 0.0875;
    NSLog(@"BasicHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",BasicHLAnnually,BasicHLHalfYear,BasicHLQuarterly,BasicHLMonthly);
    
    //calculate LSD basic
    double basicLSDAnnually = basicLSDRate * (BasicSA/1000) * 1;
    double basicLSDHalfYear = basicLSDRate * (BasicSA/1000) * 0.5125;
    double basicLSDQuarterly = basicLSDRate * (BasicSA/1000) * 0.2625;
    double basicLSDMonthly = basicLSDRate * (BasicSA/1000) * 0.0875;
    NSLog(@"BasicLSD A:%.3f, S:%.3f, Q:%.3f, M:%.3f",basicLSDAnnually,basicLSDHalfYear,basicLSDQuarterly,basicLSDMonthly);
    
    //calculate Total basic premium
    double basicTotalA = BasicAnnually + BasicHLAnnually - basicLSDAnnually;
    double basicTotalS = BasicHalfYear + BasicHLHalfYear - basicLSDHalfYear;
    double basicTotalQ = BasicQuarterly + BasicHLQuarterly - basicLSDQuarterly;
    double basicTotalM = BasicMonthly + BasicHLMonthly - basicLSDMonthly;
    NSLog(@"BasicTotal A:%.3f, S:%.3f, Q:%.3f, M:%.3f",basicTotalA,basicTotalS,basicTotalQ,basicTotalM);
    /*
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    //    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:22.368511]];
    NSString *numberString2 = [formatter stringFromNumber:[NSNumber numberWithFloat:22.364511]];
    NSLog(@"result 1:%@, result 2:%@",numberString,numberString2);
    [formatter release];*/

    NSString *htmlBasic = [[NSString alloc] initWithFormat:
                            @"<html><body><table border='1' width='500' align='center'> "
                            "<tr>"
                            "<td>Description</td><td>Annually</td><td>Half-Yearly</td><td>Quarterly</td><td>Monthly</td>"
                            "</tr>"
                            "<tr>"
                            "<td>Basic</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td>"
                            "</tr>"
                            "<tr>"
                            "<td>Occupation Loading</td><td></td><td></td><td></td><td></td>"
                            "</tr>"
                            "<tr>"
                            "<td>Health Loading</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td>"
                            "</tr>"
                            "<tr>"
                            "<td>Policy Fee Loading</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td>"
                            "</tr>"
                            "<tr>"
                            "<td>Sub-Total</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td>"
                            "</tr>",BasicAnnually,BasicHalfYear,BasicQuarterly,BasicQuarterly,BasicHLAnnually,BasicHLHalfYear,BasicHLQuarterly,BasicHLMonthly,basicLSDAnnually,basicLSDHalfYear,basicLSDQuarterly,basicLSDMonthly,basicTotalA,basicTotalS,basicTotalQ,basicTotalM];
    
    NSString *htmlTail = [[NSString alloc] initWithFormat:
                           @"<tr><td colspan='5'>&nbsp;</td></tr>"
                           "<tr>"
                           "<td>Total</td><td></td><td></td><td></td><td></td>"
                           "</tr>"
                           "</table></body></html>"];
    
    if ([riderCode count] != 0) {
        NSLog(@"append rider");
        NSString *htmlRider = [[NSString alloc] initWithFormat:
                               @"<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>"
                               "<tr>"
                               "<td>Rider</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
                               "</tr>"
                               "<tr>"
                               "<td>&nbsp; - Annually</td><td>%@</td><td></td><td></td><td></td>"
                               "</tr>"
                               "<tr>"
                               "<td>&nbsp; - Half-yearly</td><td></td><td>%@</td><td></td><td></td>"
                               "</tr>"
                               "<tr>"
                               "<td>&nbsp; - Quarterly</td><td></td><td></td><td>%@</td><td></td>"
                               "</tr>"
                               "<tr>"
                               "<td>&nbsp; - Monthly</td><td></td><td></td><td></td><td>%@</td>"
                               "</tr>",annualRiderTot,halfRiderTot,quarterRiderTot,monthRiderTot];
        
        NSString *htmlStr = [htmlBasic stringByAppendingString:htmlRider];
        NSString *htmlString = [htmlStr stringByAppendingString:htmlTail];
        NSURL *baseURL = [NSURL URLWithString:@""];
        [WebView loadHTMLString:htmlString baseURL:baseURL];
    } else {
        NSString *htmlString = [htmlBasic stringByAppendingString:htmlTail];
        NSURL *baseURL = [NSURL URLWithString:@""];
        [WebView loadHTMLString:htmlString baseURL:baseURL];
    }
    
    
}

-(void)calculateRiderPrem
{
    NSUInteger i;
    for (i=0; i<[riderCode count]; i++) {
        
        //getpentacode
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            if ([[riderCode objectAtIndex:i] isEqualToString:@"C+"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"1"]) {
                    plnOptC = [[NSString alloc] initWithString:@"L"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"2"]) {
                    plnOptC = [[NSString alloc] initWithString:@"I"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"3"]) {
                    plnOptC = [[NSString alloc] initWithString:@"B"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"4"]) {
                    plnOptC = [[NSString alloc] initWithString:@"N"];
                }
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",plnOptC];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"HMM"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"H150"]) {
                    planOptHMM = [[NSString alloc] initWithString:@"HMM_150"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"H200"]) {
                    planOptHMM = [[NSString alloc] initWithString:@"HMM_200"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"H300"]) {
                    planOptHMM = [[NSString alloc] initWithString:@"HMM_300"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"H400"]) {
                    planOptHMM = [[NSString alloc] initWithString:@"HMM_400"];
                }
                
                if ([[riderDeduct objectAtIndex:i] isEqualToString:@"1"]) {
                    deducHMM = [[NSString alloc] initWithString:@"5000"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"2"]) {
                    deducHMM = [[NSString alloc] initWithString:@"10000"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"3"]) {
                    deducHMM = [[NSString alloc] initWithString:@"10000"];
                }
                pentaSQL = [[NSString alloc] initWithFormat:
                        @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HMM\" AND PlanOption=\"%@\" AND Deductible=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planOptHMM,deducHMM,[riderAge objectAtIndex:i],[riderAge objectAtIndex:i]];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"HSP_II"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"STD"]) {
                    planHSPII = [[NSString alloc] initWithString:@"S"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"DLX"]) {
                    planHSPII = [[NSString alloc] initWithString:@"D"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"PRE"]) {
                    planHSPII = [[NSString alloc] initWithString:@"P"];
                }
                pentaSQL = [[NSString alloc] initWithFormat:
                        @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",planHSPII];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"MG_II"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"M100"]) {
                    planMGII = [[NSString alloc] initWithString:@"MG_II_100"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"M200"]) {
                    planMGII = [[NSString alloc] initWithString:@"MG_II_200"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"M300"]) {
                    planMGII = [[NSString alloc] initWithString:@"MG_II_300"];
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"M400"]) {
                    planMGII = [[NSString alloc] initWithString:@"MG_II_400"];
                }
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",planMGII];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I40R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID40R"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND PremPayOpt=\"%d\"",[riderCode objectAtIndex:i],self.requestMOP];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"ICR"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"ICR\" AND Smoker=\"%@\"",[riderSmoker objectAtIndex:i]];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"MG_IV"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"MV150"]) {
                    planMGIV = [[NSString alloc] initWithFormat:@"MGIVP_150"];
                } else  if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"MV200"]) {
                    planMGIV = [[NSString alloc] initWithFormat:@"MGIVP_200"];
                } else  if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"MV300"]) {
                    planMGIV = [[NSString alloc] initWithFormat:@"MGIVP_300"];
                } else  if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"MV400"]) {
                    planMGIV = [[NSString alloc] initWithFormat:@"MGIVP_400"];
                }
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"MG_IV\" AND PlanOption=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planMGIV,[riderAge objectAtIndex:i],[riderAge objectAtIndex:i]];
            }
            else {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",[riderCode objectAtIndex:i]];
            }
            
            NSLog(@"%@",pentaSQL);
            const char *query_stmt = [pentaSQL UTF8String];
            if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    planCodeRider =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    
                } else {
                    NSLog(@"error access PentaPlanCode");
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        
        int numTerm = [[riderTerm objectAtIndex:i] intValue];
        int numSA = [[riderSA objectAtIndex:i] intValue];
        NSLog(@"1-riderTerm:%d, riderSA:%d",numTerm,numSA);
        [self getRiderRate:planCodeRider riderTerm:numTerm];
        [self getRiderLSDRate:numSA];
        NSLog(@"riderRate:%d, riderLSD:%d",riderRate,riderLSDRate);
        
        //calculate rider
        double ridSA = [[riderSA objectAtIndex:i] doubleValue];
        double ridAnn = riderRate * (ridSA/1000) * 1;
        double ridHalf = riderRate * (ridSA/1000) * 0.5125;
        double ridQuarter = riderRate * (ridSA/1000) * 0.2625;
        double ridMonth = riderRate * (ridSA/1000) * 0.0875;
        NSLog(@"Rider A:%.3f, S:%.3f, Q:%.3f, M:%.3f",ridAnn,ridHalf,ridQuarter,ridMonth);
        
        //calculate rider health loading
        double riderHLoad;
        if ([riderHL1K count] != 0) {
            riderHLoad = [[riderHL1K objectAtIndex:i] doubleValue];
        } else if ([riderHL100 count] != 0) {
            riderHLoad = [[riderHL100 objectAtIndex:i] doubleValue];
        } else if ([riderHLP count] != 0) {
            riderHLoad = [[riderHLP objectAtIndex:i] doubleValue];
        }
        double ridHLAnn = riderHLoad * (ridSA/1000) * 1;
        double ridHLHalf = riderHLoad * (ridSA/1000) * 0.5125;
        double ridHLQuarter = riderHLoad * (ridSA/1000) * 0.2625;
        double ridHLMonth = riderHLoad * (ridSA/1000) * 0.0875;
        NSLog(@"RiderHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",ridHLAnn,ridHLHalf,ridHLQuarter,ridHLMonth);
        
        //calculate rider LSD
        double ridLSDAnn = riderLSDRate * (ridSA/1000) * 1;
        double ridLSDHalf = riderLSDRate * (ridSA/1000) * 0.5125;
        double ridLSDQuarter = riderLSDRate * (ridSA/1000) * 0.2625;
        double ridLSDMonth = riderLSDRate * (ridSA/1000) * 0.0875;
        NSLog(@"RiderLSD A:%.3f, S:%.3f, Q:%.3f, M:%.3f",ridLSDAnn,ridLSDHalf,ridLSDQuarter,ridLSDMonth);
        
        //calculate rider Total
        double riderTotalA = ridAnn + ridHLAnn - ridLSDAnn;
        double riderTotalS = ridHalf + ridHLHalf - ridLSDHalf;
        double riderTotalQ = ridQuarter + ridHLQuarter - ridLSDQuarter;
        double riderTotalM = ridMonth + ridHLMonth - ridLSDMonth;
        annualRiderTot = [[NSString alloc] initWithFormat:@"%.3f",riderTotalA];
        halfRiderTot = [[NSString alloc] initWithFormat:@"%.3f",riderTotalS];
        quarterRiderTot = [[NSString alloc] initWithFormat:@"%.3f",riderTotalQ];
        monthRiderTot = [[NSString alloc] initWithFormat:@"%.3f",riderTotalM];
        NSLog(@"RiderTotal A:%@, S:%@, Q:%@, M:%@",annualRiderTot,halfRiderTot,quarterRiderTot,monthRiderTot);
    }
}

#pragma mark - handle db

-(void)getBasicPentaRate
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Basic_Prem WHERE PlanCode=\"%@\" AND FromTerm=\"%d\" AND FromMortality=0",[self.requestPlanCode description],self.requestTerm];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicRate =  sqlite3_column_int(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Basic_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getBasicLSDRate
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LSD FROM tbl_SI_Trad_LSD_HLAIB WHERE PremPayOpt=\"%d\" AND FromSA <=\"%@\" AND ToSA >= \"%@\"",self.requestMOP,[self.requestBasicSA description],[self.requestBasicSA description]];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicLSDRate =  sqlite3_column_int(statement, 0);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

/*------RiderPart----*/
-(void)checkExistRider
{
    riderCode = [[NSMutableArray alloc] init];
    riderDesc = [[NSMutableArray alloc] init];
    riderTerm = [[NSMutableArray alloc] init];
    riderSA = [[NSMutableArray alloc] init];
    riderPlanOpt = [[NSMutableArray alloc] init];
    riderUnit = [[NSMutableArray alloc] init];
    riderDeduct = [[NSMutableArray alloc] init];
    riderHL1K = [[NSMutableArray alloc] init];
    riderHL100 = [[NSMutableArray alloc] init];
    riderHLP = [[NSMutableArray alloc] init];
    riderCustCode = [[NSMutableArray alloc] init];
    riderSmoker = [[NSMutableArray alloc] init];
    riderAge = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
            @"SELECT a.RiderCode, b.RiderDesc, a.RiderTerm, a.SumAssured, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, a.HL100SA, a.HLPercentage, c.CustCode,d.Smoker,d.ALB from Trad_Rider_Details a, tbl_SI_Trad_Rider_Profile b, tbl_SI_Trad_LAPayor c, tbl_Clt_Profile d WHERE a.RiderCode=b.RiderCode AND a.PTypeCode=c.PTypeCode AND a.Seq=c.Sequence AND d.CustCode=c.CustCode AND a.SINo=c.SINo AND a.SINo=\"%@\"", [self.requestSINo description]];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [riderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [riderDesc addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                
                const char *RTerm = (const char *) sqlite3_column_text(statement, 2);
                [riderTerm addObject:RTerm == NULL ? nil :[[NSString alloc] initWithUTF8String:(const char *)RTerm]];
                 
                const char *RsumA = (const char *) sqlite3_column_text(statement, 3);
                [riderSA addObject:RsumA == NULL ? nil :[[NSString alloc] initWithUTF8String:RsumA]];
                
                const char *plan = (const char *) sqlite3_column_text(statement, 4);
                [riderPlanOpt addObject:plan == NULL ? nil :[[NSString alloc] initWithUTF8String:plan]];

                const char *uni = (const char *) sqlite3_column_text(statement, 5);
                [riderUnit addObject:uni == NULL ? nil :[[NSString alloc] initWithUTF8String:uni]];

                const char *deduct2 = (const char *) sqlite3_column_text(statement, 6);
                [riderDeduct addObject:deduct2 == NULL ? nil :[[NSString alloc] initWithUTF8String:deduct2]];
                
                const char *ridHL = (const char *)sqlite3_column_text(statement, 7);
                [riderHL1K addObject:ridHL == NULL ? nil :[[NSString alloc] initWithUTF8String:ridHL]];
                
                const char *ridHL100 = (const char *)sqlite3_column_text(statement, 8);
                [riderHL100 addObject:ridHL100 == NULL ? nil :[[NSString alloc] initWithUTF8String:ridHL100]];
                
                const char *ridHLP = (const char *)sqlite3_column_text(statement, 9);
                [riderHLP addObject:ridHLP == NULL ? nil :[[NSString alloc] initWithUTF8String:ridHLP]];
                
                [riderCustCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)]];
                [riderSmoker addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]];
                [riderAge addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRate:(NSString *)plan riderTerm:(int)term
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Basic_Prem WHERE PlanCode=\"%@\" AND FromTerm=\"%d\" AND FromMortality=0",plan,term];
        
        NSLog(@"%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_int(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Basic_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderLSDRate:(int)sumAssured
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LSD FROM tbl_SI_Trad_LSD_HLAIB WHERE PremPayOpt=\"%d\" AND FromSA <=\"%d\" AND ToSA >= \"%d\"",self.requestMOP,sumAssured,sumAssured];
        
        NSLog(@"%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderLSDRate =  sqlite3_column_int(statement, 0);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - memory management

- (void)viewDidUnload
{
    [self setRequestPlanCode:nil];
    [self setWebView:nil];
    [self setRequestBasicHL:nil];
    [self setRequestBasicSA:nil];
    [self setRiderCode:nil];
    [self setRiderSA:nil];
    [self setRiderHL1K:nil];
    [self setRiderHL100:nil];
    [self setRiderHLP:nil];
    [self setRequestSINo:nil];
    [self setRiderTerm:nil];
    [self setRiderDesc:nil];
    [self setPlanCodeRider:nil];
    [self setRiderPlanOpt:nil];
    [self setRiderUnit:nil];
    [self setRiderDeduct:nil];
    [self setPentaSQL:nil];
    [self setPlnOptC:nil];
    [self setPlanOptHMM:nil];
    [self setDeducHMM:nil];
    [self setPlanHSPII:nil];
    [self setPlanMGII:nil];
    [self setRiderAge:nil];
    [self setRiderSmoker:nil];
    [self setRiderCustCode:nil];
    [self setPlanMGIV:nil];
    [self setAnnualRiderTot:nil];
    [self setHalfRiderTot:nil];
    [self setQuarterRiderTot:nil];
    [self setMonthRiderTot:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [annualRiderTot release];
    [halfRiderTot release];
    [quarterRiderTot release];
    [monthRiderTot release];
    [planMGIV release];
    [riderSmoker release];
    [riderCustCode release];
    [riderAge release];
    [planMGII release];
    [planHSPII release];
    [planOptHMM release];
    [deducHMM release];
    [plnOptC release];
    [pentaSQL release];
    [riderPlanOpt release];
    [riderUnit release];
    [riderDeduct release];
    [planCodeRider release];
    [riderDesc release];
    [riderTerm release];
    [requestSINo release];
    [riderHLP release];
    [riderHL100 release];
    [riderHL1K release];
    [riderSA release];
    [riderCode release];
    [requestPlanCode release];
    [WebView release];
    [requestBasicSA release];
    [requestBasicHL release];
    [super dealloc];
}

@end
