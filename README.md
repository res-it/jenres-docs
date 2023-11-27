# Public Jenres Documentation

Jenres is a tool that allows you to use OpenAI's GPT-4 AI to automatically respond to issues on GitHub.
It is free to use for public repositories on GitHub, but you need to provide the OpenAI API key that will be charged for GPT-4 usage.

# Start using Jenres
To use Jenres, you need to follow the following procedure:

### Install the Jenres Github App in your repository
1. Visit https://github.com/apps/jenres and click on "Configure" and install the app on your repository or your organization.

### Securely declare ownership of the repository
2. Download from [here](https://raw.githubusercontent.com/res-it/jenres-docs/main/jenres-cli.sh) the `jenres-cli.sh` file into the working copy of your public GitHub repository.
3. Run the command `./jenres-cli.sh generate-keys`. This command generates a pair of private and public keys that will be used to sign secrets.
4. Commit the public key and push on the main branch.

### Register on Jenres your OpenAI API key to be used for this repository 
5. Run `./jenres-cli.sh register-secrets` and enter your OPENAI API KEY enabled for GPT4.

ℹ️ Note: the use of GPT4 will be charged to the user. Without the OpenAI API key, Jenres will not work. Goes without saying that we will not use your API key for any other purpose than to use it for Jenres on your repository.

⚠️ Verify the data that will be shared with the Jenres APIs. Make sure the URL is of the type `https://jenres-api.aws.res-it.com`.


### Application examples

#### listen function

It is possible to solve your git issue with **Jenres Listen**. In order to do that, create a new issue with a title and naming `@jenres` in the issue content. A pull request will be opened by jenres at end of the elaboration.

| Issue title   | translate comments and docstrings in english
| Issue content | @jenres Please review the file 'hello_world.py' and translate any non-English comments and docstrings into English

#### housekeeping function

It is also possible to schedule a set of duties that you wish to be carried out periodically with **Jenres Housekeeping** function. 

- Add a file called "housekeeping.yaml" inside the ".jenres/" folder.

- Add the detail about the duty and time scheduling, for example `* * * * *` check [here](https://en.wikipedia.org/wiki/Cron) for more information. You can check your cron expressions [here](https://crontab.guru/).



>      duties:
>
>        head_comment:
>
>          cron: "* * * * *"
>
>          prompt: Add a docstring with Code Description at the beginning of each module in {file_path}, if it is missing


ℹ️ Note: It is possible to tell Jenres the path of the file to be reviewd by `@jenres`, or use the `{file_path}` mechanism so that `@jenres` reviews every file in the repository.

# 

For any problems or questions, do not hesitate to contact by opening issues in the repository [github.com/res-it/jenres-docs](https://github.com/res-it/jenres-docs/issues)
