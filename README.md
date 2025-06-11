# GitHub Repository Collaborator Manager

This repository provides a simple Bash script (`manage-github-access.sh`) to help you **list** and **add** collaborators to your GitHub repositories using the GitHub CLI (`gh`).

---

## About the Script

The `manage-github-access.sh` script enables automation and centralized management of repository collaborators.  
It allows you to:

- List all current collaborators for a given repository.
- Add a new collaborator to a repository with a specified permission level (read, write, or admin).

### **Prerequisites**

- [GitHub CLI (`gh`)](https://cli.github.com/) must be installed and authenticated on your system.
- [`jq`](https://stedolan.github.io/jq/) for JSON parsing.
- Sufficient permissions (admin access) on the target repository to add collaborators.

---

## Usage

Make the script executable if it isn't already:

```bash
chmod +x manage-github-access.sh
```

Run the script with the following syntax:

### **1. List Collaborators**

```bash
./manage-github-access.sh <owner> <repo>
```

- **owner**: GitHub username or organization that owns the repository.
- **repo**: Name of the repository.

**Example:**

```bash
./manage-github-access.sh my-org my-repo
```

This will list all collaborators for `my-org/my-repo` in a table format.

---

### **2. Add a Collaborator**

```bash
./manage-github-access.sh <owner> <repo> add <username> [permission]
```

- **owner**: GitHub username or organization.
- **repo**: Name of the repository.
- **add**: The literal keyword `add` to indicate you wish to add a collaborator.
- **username**: The GitHub username to add as a collaborator.
- **permission**: *(Optional)* Permission level for the collaborator:
  - `pull` (read-only)
  - `push` (write access, **default**)
  - `admin` (full admin access)

**Examples:**

```bash
# Add user 'alice' with write (push) permission (default)
./manage-github-access.sh my-org my-repo add alice

# Add user 'bob' with read-only (pull) permission
./manage-github-access.sh my-org my-repo add bob pull

# Add user 'carol' with admin permission
./manage-github-access.sh my-org my-repo add carol admin
```

---

## Output

- On listing, you will see a table of current collaborators, their type, and permissions.
- On adding, the script will output a confirmation message and the result of the GitHub API call.

---

## Notes

- The script prints the script owner (your GitHub login, or system username if not authenticated).
- You must have permission on the target repo to add collaborators.
- For private repositories, the invited user may need to accept the invitation before access is granted.

---

## Troubleshooting

- Ensure `gh` is authenticated: run `gh auth login` if you haven't already.
- Make sure you have the required permissions for the repository.
- If you get errors related to `jq`, install it with your package manager (e.g., `sudo apt install jq` or `brew install jq`).

---

## License

MIT
