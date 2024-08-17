
# Jr Bank App


## 1. Creating your EC2 Instance

1. The VPC that you’re launching your instance into must have an internet gateway attached to it. (Automatically setup)
2. The instance must be assigned a public IP address. (Auto-asigned)
3. We will add a security group rule to allow SSH from the IP address of the device that you’ll be logging in from (such as your work laptop). `(Port = 22, Source = 0.0.0/0)`
4. We add another security group rules to allow HTTP and HTTPS traffic from the internet. `(Port = 80, Source = 0.0.0.0/0)`
5. Finally, we add a security group for Jenkins to allow it to connect to our instance. `(Port = 8080, Source = 0.0.0/0)`


## 2. Jenkins

> [!NOTE]  
>This Jenkins code snippet performs several tasks related to setting up a Jenkins server on a Debian-based system. Here's a breakdown of what each command does:

1. **Update and Install Packages:**
    ```bash
    sudo apt update && sudo apt install fontconfig openjdk-17-jre software-properties-common
    ```
    - `sudo apt update`: Updates the list of available packages and their versions.
    - `sudo apt install fontconfig openjdk-17-jre software-properties-common`: Installs the `fontconfig`, `openjdk-17-jre` (Java Runtime Environment), and `software-properties-common` packages.

2. **Add Python PPA and Install Python 3.7:**
    ```bash
    sudo add-apt-repository ppa:deadsnakes/ppa && sudo apt install python3.7 python3.7-venv
    ```
    - `sudo add-apt-repository ppa:deadsnakes/ppa`: Adds the deadsnakes PPA (Personal Package Archive), which contains newer versions of Python.
    - `sudo apt install python3.7 python3.7-venv`: Installs Python 3.7 and the Python 3.7 virtual environment package.

3. **Download Jenkins GPG Key:**
    ```bash
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    ```
    - `sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key`: Downloads the Jenkins GPG key and saves it to `/usr/share/keyrings/jenkins-keyring.asc`. This key is used to verify the authenticity of the Jenkins packages.

4. **Add Jenkins Repository and Update Package List:**
    ```bash
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    ```
    - `echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null`: Adds the Jenkins repository to the list of sources from which APT will fetch packages. The `signed-by` option specifies the key to use for verifying the packages from this repository.

These steps collectively prepare the system to install Jenkins and ensure that the necessary dependencies (Java, Python 3.7, etc.) are in place.


### Full Jenkins Installation Code:
```bash
    $sudo apt update && sudo apt install fontconfig openjdk-17-jre software-properties-common && sudo add-apt-repository ppa:deadsnakes/ppa && sudo apt install python3.7 python3.7-venv
    $sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    $echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    $sudo apt-get update
    $sudo apt-get install jenkins
    $sudo apt-get upgrade
    $sudo systemctl start jenkins
    $sudo systemctl status jenkins
```

### Connecting to Jenkins by Web Browser

*Remember we set up a security group for Jenkins to be able to access it?* 

**Well now that it is setup on our Ubuntu instance, we can access Jenkins through our web browser!**

![Connecting to Jenkins through your Instance](https://github.com/joesghub/kura_deployment_1/blob/main/Screenshots/Connecting%20to%20Jenkins%20through%20your%20Instance.png?raw=true)


### Steps to Connect to Jenkins through Webview

1. Copy the Public IPv4 address (Green Box 1) and attach the Jenkins port number to access the webpage `0.0.0.0:8080`

2. Unlock Jenkins with the password stored in `/var/lib/jenkins/secrets/initialAdminPassword`

3. Use `sudo cat /var/lib/jenkins/secrets/initialAdminPassword` in your terminal and enter the pasword into the Jenkins Sign-In page

4. Select "Install suggested plugins" and create a first admin user.

## 3. Connecting Github to your Jenkins (Multi-Branch Pipeline)

1. Click on “New Item” in the menu on the left of the page and Enter a name for your pipeline.

2. Select “Multibranch Pipeline”, name your pipeline, and select “Add source” under “Branch Sources” for “GitHub”.

3. Click “+ Add” and select “Jenkins”. In the resulting window, make sure “Kind” reads “Username and password”.

4. Under “Username” enter your GitHub username and under “Password” enter your GitHub personal access token.

5. Select your Github credentials, enter the repository HTTPS URL, and click "Validate".

6. Skip assigning the Jenkins Configuration Url.


## 4. System Resources Script
To ensure our app maintains stability, I created a script to check the top 20 system resources consuming CPU.

I started by assigning the first 20 system resources pulled from the `top` command sorted by CPU in descending order for 1 batch in a file to a variable.

Then, I checked the CPU file  after the first 6 lines of the `top` output then isolating the user and %cpu column values.

Once the %cpu values are accessible I used a `for loop` to compare each value to a preset upper limit value. 

The `for loop` uses a counter to tally the amount of resources above the limit.

Finally, the script delivers the amount of programs overaging or that there are none.



## 5. AWS Command Line Interface

      The AWS Command Line Interface (AWS CLI) is an open source tool that enables you to interact with AWS services using commands in your command-line shell. With minimal configuration, the AWS CLI enables you to start running commands that implement functionality equivalent to that provided by the browser-based AWS Management Console from the command prompt in your terminal program

      The AWS CLI provides direct access to the public APIs of AWS services. You can explore a service's capabilities with the AWS CLI, and develop shell scripts to manage your resources. In addition to the low-level, API-equivalent commands, several AWS services provide customizations for the AWS CLI. Customizations can include higher-level commands that simplify using a service with a complex API. [^1]
[^1]:https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html

1. **Download the AWS CLI Installer**:
   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   ```

2. **Unzip the Installer**:
   ```bash
   unzip awscliv2.zip
   ```

3. **Install the AWS CLI**:
   ```bash
   sudo ./aws/install
   ```

4. **Verify the Installation**:
   ```bash
   aws --version
   ```

### Expected Output
After running the `aws --version` command, you should see something like:
```
aws-cli/2.13.4 Python/3.9.11 Linux/5.10.16-arch1-1 exe/x86_64.ubuntu.20 prompt/off
```
![AWS CLI Version](https://github.com/joesghub/Jr_Bank_App/blob/main/Screenshots/AWS%20CLI%20Version.png?raw=true)

This indicates that the AWS CLI has been installed successfully and is ready for use.

## 6. Python Virtual Environment and AWS ElasticBeanstalk CLI

In order to successfully initiate a Beanstalk environment to run our app through we need to install the proper resources first.

### Python Virtual Environment

      When you activate a virtual environment for your project, your project becomes its own self contained application, independent of the system installed Python and its modules.

      Your new virtual environment has its own pip to install libraries, its own libraries folder, where new libraries are added, and its own Python interpreter for the Python version you used to activate the environment.

      With this new environment, your application becomes self-contained and you get some benefits such as:

      - Your development environment is contained within your project, becomes isolated, and does not interfere with your system installed Python or other virtual environments
      - You can create a new virtual environment for multiple Python versions
      - You are able to download packages into your project without admin privileges
      - You can easily package your application and share with other developers to replicate
      - You can easily create a list of dependencies and sub dependencies in a file, for your project, which makes it easy for other developers to replicate and install all the dependencies used within your environment[^2]
[^1]:https://www.freecodecamp.org/news/how-to-setup-virtual-environments-in-python/



1. **Switch to the user "jenkins"**

2. **Create a password for the user "jenkins"**:
   ```bash
   sudo passwd jenkins
   ```

3. **Switch to the jenkins user by running**:
   ```bash
   sudo su - jenkins
   ```

4. **Navigate to the pipeline directory within the jenkins "workspace"**:
   ```bash
   cd workspace/[name-of-multibranch-pipeline]
   ```
5. **Activate the Python Virtual Environment**:
   ```bash
   source venv/bin/activate
   ```

![Python Venv and AWS EB CLI Version](https://github.com/joesghub/Jr_Bank_App/blob/main/Screenshots/Python%20Venv%20and%20AWS%20EB%20CLI%20Version.png?raw=true)

### AWS EB CLI

      The EB CLI is a command line interface for AWS Elastic Beanstalk that provides interactive commands that simplify creating, updating and monitoring environments from a local repository. Use the EB CLI as part of your everyday development and testing cycle as an alternative to the Elastic Beanstalk console.[^3]
[^3]:https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html


1. **Install AWS EB CLI on the Jenkins Server with the following commands**:
   ```bash
   pip install awsebcli 
   eb --version
   ```

2. **Configure AWS CLI with the folling command:**:
   ```bash
   aws configure
   a. Enter your access key
   b. Enter your secret access key
   c. region: "us-east-1"
   d. output format" "json"
   ```

3. **Check to see if AWS CLI has been configured by entering**:
   ```bash
   aws ec2 describe-instances 
   ```
![EC2 Instance Configuration in AWS CLI](https://github.com/joesghub/Jr_Bank_App/blob/main/Screenshots/EC2%20Instance%20Configuration%20in%20AWS%20CLI.png?raw=true)
![AWS Instance for EBS Environment](https://github.com/joesghub/Jr_Bank_App/blob/main/Screenshots/AWS%20Instance%20for%20EBS%20Environment.png?raw=true)

4. **Initialize AWS Elastic Beanstalk CLI**:
   ```bash
   eb init
   a. Set the default region to: us-east-1
   b. Enter an application name (or leave it as default)
   c. Select python3.7
   d. Select "no" for code commit
   e. Select "yes" for SSH and select a "KeyPair"
   ```

5. **Add a "deploy" stage to the Jenkinsfile**:
   ```bash
   Add the following code block (modify the code with your environment name and remove the square brackets) AFTER the "Test" Stage:

   stage ('Deploy') {
          steps {
              sh '''#!/bin/bash
              source venv/bin/activate
              eb create [enter-name-of-environment-here] --single
              '''
          }
      }
   ```
> [!IMPORTANT]  
>TTHE SYNTAX OF THE JENKINSFILE IS VERY SPECIFIC! MAKE SURE THAT THE STAGES AND CURLY BRACKETS ARE IN THE CORRECT ORDER OTHERWISE THE PIPELINE WILL NOT BUILD! See https://www.jenkins.io/doc/book/pipeline/syntax/ for more information.

![Jenkins Build Stage](https://github.com/joesghub/Jr_Bank_App/blob/main/Screenshots/Jenkins%20Build%20Stage.png?raw=true)
![Jenkins Test and Deploy Stages](https://github.com/joesghub/Jr_Bank_App/blob/main/Screenshots/Jenkins%20Test%20and%20Deploy%20Stages.png?raw=true)

6. **Push these changes to the GH Repository, Navigate back to the Jenkins Console and build the pipeline again.**
   ```bash
   If the pipeline sucessfully completes, navigate to AWS Elastic Beanstalk in the AWS Console and check for the environment that is created. The application should be running at the domain created by Elastic Beanstalk.
   ```
![EBS prod-env](https://github.com/joesghub/Jr_Bank_App/blob/main/Screenshots/EBS%20prod-env.png?raw=true)


## 7. AWS CLI and AWS EB CLI

I observed that including a deployment stage in our Jenkins pipeline too early—before confirming the success of the build and test stages—could lead to failed tests.

It’s essential to first complete testing in Jenkins without a deployment stage. Once the tests pass, we can then add the deployment stage to the Jenkins file after the instance and environment are active.

Jenkins automatically rebuilds and tests the code from the latest push to GitHub as the Jenkins file is updated.

Upon successful testing, the deployment is carried out to the Elastic Beanstalk environment set up through the CLI, which is running on the EC2 instance configured via the AWS CLI.


## 8. System Diagram

![System Architechture](https://github.com/joesghub/Jr_Bank_App/blob/main/Screenshots/Jr%20Bank%20App%20System%20Architecture.png?raw=true)


## 9. Issues and Troubleshooting

I had issues pusihing to repository and received the error below:

```bash
ubuntu@ip-172-31-17-167:~/Jr_Bank_App$ git remote add origin https://github.com/joesghub/Jr_Bank_App
error: remote origin already exists.
ubuntu@ip-172-31-17-167:~/Jr_Bank_App$ git push -u -f origin master
error: src refspec master does not match any
error: failed to push some refs to 'https://github.com/kura-labs-org/C5-Deployment-Workload-2.git'
ubuntu@ip-172-31-17-167:~/Jr_Bank_App$ git remote -v
origin  https://github.com/kura-labs-org/C5-Deployment-Workload-2.git (fetch)
origin  https://github.com/kura-labs-org/C5-Deployment-Workload-2.git (push)
ubuntu@ip-172-31-17-167:~/Jr_Bank_App$ git remote add origin https://github.com/joesghub/Jr_Bank_App
error: remote origin already exists.
ubuntu@ip-172-31-17-167:~/Jr_Bank_App$ git remote set-url origin https://github.com/joesghub/Jr_Bank_App
ubuntu@ip-172-31-17-167:~/Jr_Bank_App$ git remote -v
origin  https://github.com/joesghub/Jr_Bank_App (fetch)
origin  https://github.com/joesghub/Jr_Bank_App (push)
ubuntu@ip-172-31-17-167:~/Jr_Bank_App$ git add .
ubuntu@ip-172-31-17-167:~/Jr_Bank_App$ git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```
I used ChatGPT to help diagnose the issues and develop solutions:

 
1. **Error: remote origin already exists**

Cause: When you tried to add a new remote repository with git remote add origin https://github.com/joesghub/Jr_Bank_App, Git returned the error because a remote named origin was already configured in your repository.
Solution: Instead of adding a new remote, you need to update the existing remote URL. You did this correctly by using the command git remote set-url origin https://github.com/joesghub/Jr_Bank_App.

2. **Error: src refspec master does not match any**

Cause: This error occurs because the branch named master does not exist in your local repository. By default, newer versions of Git initialize the main branch with the name main instead of master.
Solution: Instead of pushing the master branch, you should push the main branch, which is the branch you're currently on. This is indicated by the output of the git status command showing you are on the main branch. 



## 10. Optimization

By using the CLI for AWS and AWS EB we can use scripts to automate the setup of our banking app. 

We could utilize a Jenkins CLI so the script could include the Jenkins setup and configuration.

This would allow for the whole app to be setup within one script!