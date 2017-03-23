//
//  AppDelegate.m
//  TEST
//
//  Created by MAC on 2016/12/19.
//  Copyright © 2016年 Wistron. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.SHOW = YES;
    
    //******************  Inin Config ******************
    ConfigPlist = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"]];
    
    //******************  Open Users firstly ******************
    NSMutableArray *ArryFromPlist = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"]];
    self.Users=([ArryFromPlist count]>0)?ArryFromPlist:[NSMutableArray new];

    //******************  setDoubleAction  ******************
    [self.TABLE setDoubleAction:@selector(Doopen)];
    
    //******************  set StatusBarItem  ******************
    [self StatusBarItem];
    
    [self.Window setTitle:[NSString stringWithFormat:@"%@ --(option+A)",[ConfigPlist objectForKey:@"DefaultType"]]];
    
    hkm = [[JFHotkeyManager alloc] init];

    [hkm bind:@"option a" target:self action:@selector(HotKeyChangeType)];
    [hkm bind:@"option z" target:self action:@selector(HIDESHOW)];
    //[hkm bind:@"option s" target:self action:@selector(password)];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


//-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
//{
//    [self.Users writeToFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"] atomically:YES];
//    return YES;
//}

- (void)Doopen{
    NSString *ip =[[self.Users objectAtIndex:self.TABLE.selectedRow] objectForKey:@"IP"];
    if([ip length]>0)
    {
        NSString *cmd =[NSString stringWithFormat:@"do shell script \"Open vnc://%@\" ",ip];
        [self RunCMD:cmd];
        
        [self password];
    }
}


-(NSString *)RunCMD:(NSString *)script {
    NSDictionary *error = [NSDictionary new];
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor *des = [appleScript executeAndReturnError:&error];
    return  des.stringValue;
}

- (void)password
{
    [NSThread sleepForTimeInterval:1];
    NSString * cmd = [NSString stringWithFormat:[ConfigPlist objectForKey:@"InputPswScript"],[[self.Users objectAtIndex:self.TABLE.selectedRow] objectForKey:@"Username"],[[self.Users objectAtIndex:self.TABLE.selectedRow] objectForKey:@"Password"]];

    //NSString * cmd = [NSString stringWithFormat:@"tell application \"Screen Sharing\"\nactivate\ntell application \"System Events\"\nkeystroke \"%@\"\nkeystroke tab\nkeystroke \"%@\"\nkeystroke tab\nend tell\nend tell\n",@"gdlocal",@"gdlocal"];
    //[self RunCMD:[NSString stringWithFormat:[ConfigPlist objectForKey:@"InputPswScript"],[[self.Users objectAtIndex:self.TABLE.selectedRow] objectForKey:@"Username"],[[self.Users objectAtIndex:self.TABLE.selectedRow] objectForKey:@"Password"]]];
    //NSLog(@"%@", cmd);
    [self RunCMD:cmd];
}

- (void)StatusBarItem {
    
    self.statusItem= [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSMenu *MainMenu = [[NSMenu alloc]init];
    //NSMenuItem *Password = [[NSMenuItem alloc] initWithTitle:@"Input_Password" action:@selector(password) keyEquivalent:@""];
    NSMenuItem *Hide = [[NSMenuItem alloc] initWithTitle:@"Hide/Show" action:@selector(HIDESHOW) keyEquivalent:@""];
    NSMenuItem *Quit = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit) keyEquivalent:@""];
    //[MainMenu addItem:Password];
    [MainMenu addItem:Hide];
    
    NSArray *Type = [ConfigPlist objectForKey:@"Type"];
    for( NSString *Name in Type )
    {
        NSMenuItem *Item = [[NSMenuItem alloc] initWithTitle:Name action:@selector(ChangeType:) keyEquivalent:@""];
        [MainMenu addItem:Item];
    }
    
    
    [MainMenu addItem:Quit];
    NSImage *menuIcon = [NSImage imageNamed:@"Menu Icon"];
    [menuIcon setTemplate:YES];
    [[self statusItem] setImage:menuIcon];
    self.statusItem.menu = MainMenu;
}

-(void) ChangeType:(NSMenuItem *) Item
{
    //******************  Save Users firstly ******************
    [self.Users writeToFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"] atomically:YES];

    //Chage DefaultType
    [ConfigPlist setValue:Item.title forKey:@"DefaultType"];
    
    //******************  Chage self.Users ******************
    NSMutableArray *ArryFromPlist = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"]];
    self.Users=([ArryFromPlist count]>0)?ArryFromPlist:[NSMutableArray new];
    
    //******************  Save DefaultType ******************
    [ConfigPlist writeToFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"] atomically:YES];
    [self.Window setTitle:[NSString stringWithFormat:@"%@ --(option+A)",[ConfigPlist objectForKey:@"DefaultType"]]];
}

-(void) HIDESHOW
{
    if (self.SHOW)
    {
        self.SHOW = NO;
    }
    else
    {
        self.SHOW =YES;
    }
}

-(void) HotKeyChangeType
{
    self.SHOW =YES;
    
    //******************  Save Users firstly ******************
    [self.Users writeToFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"] atomically:YES];
    
    //******************  Chage self.Users ******************
    NSArray* TypeArry = [ConfigPlist objectForKey:@"Type"];

    for (int i=0; i < TypeArry.count; i++ )
    {
        if ([[TypeArry objectAtIndex:i] isEqualToString:[ConfigPlist objectForKey:@"DefaultType"]])
        {
            i++;
            if (i == TypeArry.count)
            {
                i=0;
            }
            
            //Chage DefaultType
            [ConfigPlist setValue:[TypeArry objectAtIndex:i] forKey:@"DefaultType"];
            //******************  Save DefaultType ******************
            [ConfigPlist writeToFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"] atomically:YES];

        }
    }
    
    //******************  Chage self.Users ******************
    NSMutableArray *ArryFromPlist = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"]];
    self.Users=([ArryFromPlist count]>0)?ArryFromPlist:[NSMutableArray new];
    [self.Window setTitle:[NSString stringWithFormat:@"%@ --(option+A)",[ConfigPlist objectForKey:@"DefaultType"]]];
}


-(void) quit
{
    [self.Users writeToFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"] atomically:YES];
    [NSApp terminate:self];
}
- (IBAction)create:(NSButton *)sender {
    //[[self.Users objectAtIndex:self.TABLE.selectedRow]setObject:@"gdlocal" forKey:@"IP"];
}
@end
