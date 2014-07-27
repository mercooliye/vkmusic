//
//  vkLoginViewController.m
//  VKAPI
//
//  Created by Alexander on 05.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "vkLoginViewController.h"

@implementation vkLoginViewController
@synthesize vkWebView;
@synthesize appID;
@synthesize delegate;
@synthesize navBar1;
@synthesize navitem;
@synthesize progress;
NSURLConnection *connvk;
NSMutableData *datavk;
NSURLConnection*connimgload;


- (void) dealloc {
    delegate=nil;
    appID=nil;
    vkWebView=nil;
    vkWebView.delegate = nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle
-(void)ok1{
   
//[self dismissModalViewControllerAnimated:YES];
   // UIAlertView *alert=[[UIAlertView alloc] initWithCoder:@"je"];
    
}

- (void)viewDidLoad
{
    [progress startAnimating];
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"]) {
        [self performSegueWithIdentifier:@"logon" sender:@"logon"];// переход на главную страницу

    }

  //  [[NSUserDefaults stand	ardUserDefaults] removeObjectForKey:@"VKAccessToken"];
  
  //  UIBarButtonItem *aButton = [[UIBarButtonItem alloc]initWithTitle:@"O'K" style:
                               // UIBarButtonItemStyleBordered target:self action:@selector(ok1)];
    
    //self.navitem.leftBarButtonItem = aButton;
    NSLog(@"logo");
    
    
    if(!vkWebView){
        self.vkWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        vkWebView.delegate = self;
        vkWebView.scalesPageToFit = YES;
        [self.view addSubview:vkWebView];
    }
    // Создаем запрос на авторизацию приложения, указываем appID (код приложения, полученный при регистрации вконтакте по ссылке: http://vkontakte.ru/editapp?act=create&site=1) и нужные нам права, в данном случае это доступ к стене (wall), к фото (photos), чтобы можно было размещать фотографии на стену пользователя.
    appID=@"4465083";
    if(!appID) {
    //    [self dismissModalViewControllerAnimated:YES];
        return;
    }
    NSString *authLink = [NSString stringWithFormat:@"http://api.vk.com/oauth/authorize?client_id=%@&scope=video,audio,notify,offline&redirect_uri=http://api.vk.com/blank.html&display=touch&response_type=token", appID];
    NSURL *url = [NSURL URLWithString:authLink];
    
    [vkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)viewDidUnload
{
}

- (void) viewDidDisappear:(BOOL)animated {
    
    
    [super viewDidDisappear:animated];
    [vkWebView stopLoading];
    
    vkWebView.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Web View Delegate

- (BOOL)webView:(UIWebView *)aWbView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    
    
    
    [progress startAnimating];
    [vkWebView setAlpha:0.5];
 
    NSURL *URL = [request URL];
    // Пользователь нажал Отмена в веб-форме
    if ([[URL absoluteString] isEqualToString:@"http://api.vk.com/blank.html#error=access_denied&error_reason=user_denied&error_description=User%20denied%20your%20request"])
   {
       
       // [alert release];
        

        //NSLog(@"НАЖАТА ОТМЕНА");

      //  [super dismissModalViewControllerAnimated:YES];
        return NO;
    }
	//NSLog(@"Request: %@", [URL absoluteString]);
	return YES;
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    

}

-(void)webViewDidFinishLoad:(UIWebView *)vkWebView

{
    [vkWebView setAlpha:1];
    [progress stopAnimating];
    // Если есть токен сохраняем его
    
    if ([vkWebView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound)
    
    {
        NSString *accessToken = [self stringBetweenString:@"access_token=" 
                                                andString:@"&" 
                                              innerString:[[[vkWebView request] URL] absoluteString]];
        
        // Получаем id пользователя, пригодится нам позднее
        NSArray *userAr = [[[[vkWebView request] URL] absoluteString] componentsSeparatedByString:@"&user_id="];
        NSString *user_id = [userAr lastObject];
        NSLog(@"User id: %@", user_id);
        
        if(user_id){
            [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"VKAccessUserId"];
            [[NSUserDefaults standardUserDefaults] synchronize ];
        }
        
        // получили доступ, перешли на главную страницу
        if(accessToken)
        
        {
            
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"VKAccessToken"];
  
            
            NSLog(accessToken);
         
            // Сохраняем дату получения токена. Параметр expires_in=86400 в ответе ВКонтакта, говорит сколько будет действовать токен.
            // В данном случае, это для примера, мы можем проверять позднее истек ли токен или нет
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"VKAccessTokenDate"];
            
            //NSLog([NSDate date]);
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *vkaid=[[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessUserId"];
            NSString *vktoken=[[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"];
            
            
            NSString *urlString = [NSString stringWithFormat:@"https://api.vk.com/method/users.get?uid=%@&fields=photo_big,uid,first_name,last_name,nickname,sex,bdate,city,country,relation,connections,mobile_phone&access_token=%@", vkaid, vktoken];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
            
            
            // создаём соединение и начинаем загрузку
            connvk= [[NSURLConnection alloc] initWithRequest:request delegate:self];
            datavk = [NSMutableData data ];
            
            
        }
        
        NSLog(@"vkWebView response: %@",[[[vkWebView request] URL] absoluteString]);
        //[(login *)delegate authComplete];
        //здесь вроде переход при нажатии отмена
    } else if ([vkWebView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound)
    
    {
        NSLog(@"Error: %@", vkWebView.request.URL.absoluteString);
       // [self performSegueWithIdentifier:@"firstpage" sender:@"firstpage"];// переход на первую страницу

        [self dismissModalViewControllerAnimated:YES];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection==connimgload)
    {
        
      //  NSData *dataimg=[[NSData alloc] init];
        NSString *photourl=[[NSUserDefaults standardUserDefaults] objectForKey:@"photo_big"];
        UIImage *imagetemp=[[UIImage alloc] init];
        NSURL* aURL = [NSURL URLWithString:photourl];
        NSData* dataimg = [[NSData alloc] initWithContentsOfURL:aURL];
        
        imagetemp=[UIImage imageWithData:dataimg];
        [[NSUserDefaults standardUserDefaults] setObject:dataimg forKey:@"imgdata"];
    }
    if (connection==connvk)
    {
          NSDictionary *vkinfo = [NSJSONSerialization JSONObjectWithData:datavk options:kNilOptions error:nil];
     
        NSArray *temp=[vkinfo objectForKey:@"response"];
        
        NSDictionary *response=[temp objectAtIndexedSubscript:0];
        
        UIDevice *devise=[[UIDevice alloc] init];
        NSString *uuid= devise.identifierForVendor.UUIDString;
      
      
        
 
       /// NSString *urlString = [NSString stringWithFormat:@"http://pp.mercool.tmweb.ru/addimg.php?name=usersimg/%@.jpg&url=%@", uuid, [response valueForKey:@"photo_big"]];
       // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
       //                                          cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        
     //   NSString *imgst=[NSString stringWithFormat:@"usersimg/%@.jpg" ,uuid];
    //    [[NSUserDefaults standardUserDefaults] setObject:imgst forKey:@"img"];
        
       // NSString *urlString2 = [NSString stringWithFormat:@"http://pp.mercool.tmweb.ru/add_user.php?nikname=%@&uidvk=//%@&id=%@&img=%@", [response valueForKey:@"nickname"],  [response valueForKey:@"uid"], uuid, imgst];
    //    NSURLRequest *imgload = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString2]
    //                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
     
     //   [[NSURLConnection alloc] initWithRequest:request delegate:self];
  //      connimgload=[[NSURLConnection alloc] initWithRequest:imgload delegate:self];

        [self performSegueWithIdentifier:@"logon" sender:@"logon"];// переход на главную страницу

    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==connvk)
    {
        [datavk appendData:data];

    }
}



-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"vkWebView Error: %@", [error localizedDescription]);
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Ошибка подключения к интернету" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
  //  [self viewDidLoad];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Methods
// получаем правильный доступ!!!
- (NSString*)stringBetweenString:(NSString*)start 
                       andString:(NSString*)end 
                     innerString:(NSString*)str 
{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

@end
