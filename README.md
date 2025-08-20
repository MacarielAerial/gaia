# Gaia

## Summary
Gaia is a template repository for python applications

## Note

* In order to enable SSH forwarding into the dev container, the host system's .bashrc has to be configured accordingly:

    ```sh
    # Start SSH Agent if not already running
    if [ -z "$SSH_AUTH_SOCK" ]; then
    # Check for a currently running instance of the agent
    RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
    if [ "$RUNNING_AGENT" = "0" ]; then
            # Launch a new instance of the agent
            ssh-agent -s &> $HOME/.ssh/ssh-agent
    fi                                                                                                                                eval `cat $HOME/.ssh/ssh-agent` > /dev/null
    fi

    # Necessary for VSCode to forward the ssh agent
    export SSH_AGENT_SOCK=$SSH_AUTH_SOCK
    ```

* In order for the correct SSH key to be used for the repo given SSH keys associated with multiple accounts are present in the host system, the ssh config file that is mounted onto the dev container has to be configured properly:

    ```sh
    # Personal GitHub account
    Host github.com
    HostName github.com
    User git
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_rsa
    # Work GitHub account
    Host github.com-work
    HostName github.com
    User git
    AddKeysToAgent yes
    IdentityFile ~/.ssh/work_rsa
    ```

# Current Feature Set

1. Isolated and deterministic development system environment with **VS Code Dev Container**
2. Isolated and determinisitc python environment with **Poetry**
3. Isolated and deterministic system and python environment with **Docker**
4. Static code analysis with tools such as **black** and **coverage** and python code testing with **pytest**
5. GitHub Action workflow for CI purpose (i.e. Build, Test and Release)

# Future Features
1. Workflow definition to package only python code and to upload to PyPI index
