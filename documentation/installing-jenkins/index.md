# Installing Jenkins

Jenkins is installed via automation but its configuration cannot be fully automated. The following manual instructions are valid for 1.647 and probably later.

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
     
## Plugins

Update all plugins on [Plugin Manager](https://buildservertmit.cloudapp.net/pluginManager/) page.

Uninstall all plugins that can be uninstalled.

Install plugins:

- [Github plugin](https://wiki.jenkins-ci.org/display/JENKINS/GitHub+Plugin)

## Add SSH key to GitHub

- Remote Desktop into buildservertmit.
- Copy contents of `C:\Users\Jenkins\.ssh\id_rsa.pub` to clipboard
- Add [SSH Key to GitHub](https://github.com/settings/ssh) 