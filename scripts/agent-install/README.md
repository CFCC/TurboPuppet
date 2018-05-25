Agent Setup
===========

Windows
-------
1) Download the install script with Edge from http://grntm.co/campup

2) Open an Explorer window to the Downloads directory.
    _Tip: You can click "Show Downloads" in Edge then click "Open Download Folder"_

3) Right-click on the ```campup``` file and click "Run With Powershell". Accept any prompts.

4) When the script completes, open the Start Menu.

5) Start typing ```cmd```. The "Command Prompt" should appear under best match. Right 
click on that and select "Run as Administrator".

6) In the command prompt, run Puppet.
    ```shell
    puppet agent -t
    ```
You should see a lot of text start to fly by. Green/White is good. Red is bad.