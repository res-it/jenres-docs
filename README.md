# Public JenRes Documentation
JenRes is a tool that allows you to use OpenAI's GPT-4 AI to automatically respond to issues and schedule duties on GitHub.
It is free to use for public repositories on GitHub, but you need to provide the OpenAI API key that will be charged for GPT-4 usage.

# Start using JenRes
To start utilizing JenRes, follow the onboarding process through CLI, as provided below. This is a secure and verified procedure to ensure that JenRes operates under the highest security and efficiency standards, making it a valuable tool for developers and organizations.  

### Requirements
JenRes is available for free to maintainers of open-source projects hosted on GitHub. For more advanced uses of the tool, please contact us.  

To use JenRes, an OpenAI API key is required. Currently, JenRes supports OpenAI's GPT-4. JenRes’ users are responsible for their own GPT-4 API costs, which will be billed directly to their OpenAI account. Users can monitor the costs of each API call by reviewing the pull request message associated with the specific task.

### Install the JenRes Github App in your repository
1. Create a public GitHub Repository.  

2. Visit [here](https://github.com/apps/jenres) and click on 'Configure'. Follow the interface instructions to install the app on your repository. Remember, the repository must be public to use JenRes for free.

### Securely declare ownership of the repository
3. Download from [here](https://raw.githubusercontent.com/res-it/jenres-docs/main/jenres-cli.sh) the `jenres-cli.sh` file and place it in the working copy of your GitHub repository.

4. Run the command `./jenres-cli.sh generate-keys` from the CLI. This command generates a pair of private and public keys that will be used to sign secrets.

5. Commit the public key and push on the main branch. Once you have done so, you can see the folder `.jenres` on the main branch of your git repository with the `pub.key` file inside.

### Register your OpenAI API key on JenRes 
6. Run `./jenres-cli.sh register-secrets` and enter your OPENAI API KEY enabled for GPT4.

ℹ️ Note: the use of GPT-4 will be charged to the user. JenRes will utilize your API key exclusively for accessing GPT-4 services on your repository.

⚠️ Verify the data that will be shared with the JenRes APIs.

### Register your SonarCloud token on JenRes - Optional
JenRes supports SonarCloud, a cloud-based code analysis service, engineered to identify coding issues across 26 diverse programming languages. With SonarCloud, the code undergoes a thorough examination against a comprehensive set of rules. These rules cover various aspects of code quality, including maintainability, reliability, and security concerns. JenRes can be configured to monitor and address a specific set of coding rules.  

7. Once you have correctly configured SonarCloud for your repository (see for procedure below), enter your SonarCloud token in the CLI.

### SonarCloud Installation - Optional 
To use SonarCloud with JenRes: 

1. Visit [here](https://github.com/apps/sonarcloud) and click on ‘Configure’. The procedure for installing the SonarCloud App is the same as that for installing the JenRes App. Select your repositories and save your choice.  

2. In the SonarCloud interface, choose `Analyze new project` and provide the name of the project you want to be analyzed. Choose the settings which best suit your needs and click on `Create New Project`.

3. Click on  `Information` to retrieve the  `project-key`. Place it in the housekeeping.yaml file to enable JenRes Housekeeping function.

4. Generate a token from [here](https://sonarcloud.io/account/security). Copy and store the token; you will use it to register secrets on JenRes.

# JenRes' Features

#### Issue Handling feature
It is possible to solve your git issue with **Issue Handling** feature. In order to do that, create a new issue with a title and naming `@jenres` in the issue content. A pull request will be opened by JenRes at end of the elaboration.

| Issue title   | translate comments and docstrings in english
| Issue content | @jenres Please review the file 'hello_world.py' and translate any non-English comments and docstrings into English

#### Housekeeping function
It is also possible to schedule a set of duties that you wish to be carried out periodically with **Housekeeping** function. 

- Add a file called "housekeeping.yaml" inside the ".jenres/" folder.

- Add the detail about the duty and time scheduling, for example `* * * * *` check [here](https://en.wikipedia.org/wiki/Cron) for more information. You can check your cron expressions [here](https://crontab.guru/).



>      duties:
>
>        duty_name:
>
>          cron: "* * * * *"
>
>          prompt: Add a docstring with Code Description at the beginning of each module in {file_path}, if it is missing

You can set up duties that act when some coding rules are violated. 



>      duties:
>
>        duty_name:
>
>          cron: "* * * * *"
>
>          sonar_project_key: my_project_key
>           
>          sonar_rules:
>           - python:S1481
>           - ...          

ℹ️ Note: It is possible to tell JenRes the path of the file to be reviewd by `@jenres`, or use the `{file_path}` mechanism so that `@jenres` reviews every file in the repository.

# End of the execution
JenRes will open a pull/request at the end of each elaboration phase. Users can review the work done and decide whether to merge the JenRes branch with the main branch. JenRes branches have a specific naming convention to distinguish them from user-created branches: 

- *jenres/issue-number* for the issue-handling function 
- *jenres/hk/name_of_the_duty* for the housekeeping function. 

For any problems or questions, do not hesitate to contact by opening issues in the repository [github.com/res-it/jenres-docs](https://github.com/res-it/jenres-docs/issues)