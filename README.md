# Gaia

## Summary

Gaia is a template repository for python applications

## Note

* In order to enable SSH forwarding into the dev container, the host system's .bashrc has to be configured accordingly:

    ```sh
    # Start SSH agent if not already running
    if [ -z "$SSH_AUTH_SOCK" ] || ! ps -p "${SSH_AGENT_PID:-}" >/dev/null 2>&1; then
        eval "$(ssh-agent -s)" >/dev/null
    fi
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
