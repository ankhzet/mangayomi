## Synchronizing fork with main repo
- take notes of the formatting settings on the current branch (from now, a working branch <working>)
- run formatting on the current branch
- pull latest changes from main repo into `main` branch
- apply the same formatting settings as noted
- format the `main` branch with shared settings
- now both branches whould differ minimally
- merge `main` branch into <working>:
    - if <working> and `main` updated same dependency - take latest
    - otherwise preffer `main` (even for replacements/removals) 
    - on other types of merge conflicts:
        - if <working> added functionality - re-add it
        - if <working> has a stylistic change - preffer <working>
        - if `main` added functionality that does not conflict with <working> - re-add it
        - if <working> and `main` introduce conflicting implementations/features - store them separately as `main-patch` and `working-patch` that could be applied on top of merge independently

### The overral goal is to
- update the codebase to keep it in sync with fork origin repo
- keep bugfixes from both
- keep non-conflicting new features from both
- upon conflicting features/fixes, allow form maintainer to pick the preffered solution