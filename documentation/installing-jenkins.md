# Installing Jenkins

Jenkins is installed via automation but is configuration cannot be fully automatted. The following manual instructions are valid for 1.647 and probably later.

## Create Jenkins' Account

Create your account to use Jenkins.

- Open Remote Desktop
- http://localhost:8080/signup
    - Enter field and click **Sign up**

Now stop others from creating Jenkins accounts.
 
- Open http://localhost:8080/configureSecurity/
- Allow users to sign up: Untick
- Click **Save**


     
# OLD NOTES

## Configure Jenkins

Change the following fields on [Configure System](https://buildservertmit.cloudapp.net/configure) page.

- Jenkins URL: https://buildservertmit.cloudapp.net/
- System Admin e-mail address: tim@26tp.com
- SMTP Server: smtp.gmail.com
- Click Advanced button in E-mail Notification section.
- Use SMTP Authentication: Yes
- User Name: tim@26tp.com
- Password: [use application password]
- Use SSL: Yes
- SMTP Port: 465
- Reply-To Address: tim@26tp.com
  
## Manage Jenkins

todo: Configure reverse proxy to prevent error message `It appears that your reverse proxy set up is broken.`. To date I've not seen any negative side effects.

## Plugin Manager

Update all plug ins on [Plugin Manager](https://buildservertmit.cloudapp.net/pluginManager/) page.

Install plugs ins:

- Bitbucket
- Powershell