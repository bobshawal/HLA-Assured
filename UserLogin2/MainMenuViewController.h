//
//  MainMenuViewController.h
//  HLA
//
//  Created by shawal sapuan on 7/17/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface MainMenuViewController : UIViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
}

@property (nonatomic,strong) id userRequest;
@property (nonatomic, assign,readwrite) int indexNo;

@property (retain, nonatomic) IBOutlet UILabel *welcomeLabel;

- (IBAction)changePwdBtnPressed:(id)sender;
- (IBAction)doLogout:(id)sender;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;


@end
