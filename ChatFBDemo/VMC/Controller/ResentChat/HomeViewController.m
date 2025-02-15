//
//  HomeViewController.m
//  HushChat
//
//  Created by Hiren on 10/5/15.
//  Copyright © 2015 openxcell. All rights reserved.
//

#import "HomeViewController.h"
#import "UsersViewController.h"
#import "FirebaseManager.h"
#import "ConversationViewController.h"

@interface HomeViewController ()
{
    NSMutableArray *conversations;
}
@property (strong, nonatomic) IBOutlet UITableView *conversationTable;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    conversations = [[NSMutableArray alloc] init];
    
    [self getConversations];
    
    self.navigationItem.backBarButtonItem  = nil;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"userSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        UsersViewController *userViewController = navigationController.viewControllers[0];
        userViewController.delegate = self;
    }
}

-(void)startNewChatWithUser:(NSDictionary *)user {
    NSLog(@"Started new chat with user....%@",user);
    [FirebaseSharedManager startNewChatToUser:[user objectForKey:@"profile"]];
}

-(void)getConversations
{
    [FirebaseSharedManager getListOfConversation:^(BOOL isSuccess, NSArray *userConversations) {
        if (isSuccess) {
            [conversations addObjectsFromArray:userConversations];
            [self.conversationTable reloadData];
        }
    }];
}

#pragma mark - TableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [conversations count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"conversationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *userConversation = [conversations[indexPath.row] objectForKey:@"userDetail"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[userConversation objectForKey:@"firstName"], [userConversation objectForKey:@"lastName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = conversations[indexPath.row];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ConversationViewController *conversationViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"conversationViewController"];
    conversationViewController.conversationDetail = dictionary;
    [self.navigationController pushViewController:conversationViewController animated:YES];
}

@end
