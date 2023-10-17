# Public Jenres Documentation

Jenres is a tool that allows you to use OpenAI's GPT-4 AI to automatically respond to issues on GitHub.
It is free to use for public repositories on GitHub, but you need to provide the OpenAI API key that will be charged for GPT-4 usage.

# Start using Jenres
To use Jenres, you need to follow the following procedure:

### Install the Jenres Github App in your repository
1. Visit https://github.com/apps/jenres and click on "Configure" and install the app on your repository or your organization.

### Securely declare ownership of the repository
2. Download the `jenres-cli.sh` file into the working copy of your public GitHub repository.
3. Run the command `./jenres-cli.sh generate-keys`. This command generates a pair of private and public keys that will be used to sign secrets.
4. Commit the public key and push on the main branch.

### Register on Jenres your OpenAI API key to be used for this repository 
5. Run `./jenres-cli.sh register-secrets` and enter your OPENAI API KEY enabled for GPT4.

ℹ️ Note: the use of GPT4 will be charged to the user. Without the OpenAI API key, Jenres will not work. Goes without saying that we will not use your API key for any other purpose than to use it for Jenres on your repository.

⚠️ Verify the data that will be shared with the Jenres APIs. Make sure the URL is of the type `https://jenres-api.aws.res-it.com`.

At this point, you can start using Jenres by creating the first issue and naming @jenres-app in the issue.

For any problems or questions, do not hesitate to contact by opening issues in the repository https://github.com/res-it/jenres-docs
