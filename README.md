# Minecraft BDS Update Script (Linux)

This script updates the BDS (Bedrock Dedicated Server) to the latest version. It requires the following dependencies to be installed on your system:

1. **Bash shell**: Ensure that the Bash shell is available on your system. If it's not already installed, you can install it using your distribution's package manager.

2. **wget command**: The `wget` command is used to download files from the internet. Make sure it's installed and accessible from the command line.

3. **unzip command**: The `unzip` command is required to extract the downloaded BDS server ZIP file. Ensure that it's installed and available in your system's PATH.

4. **awk command**: The `awk` command is used for text processing and data extraction. Make sure it's installed and accessible from the command line.

5. **tr command**: The `tr` command is used for character translation and manipulation. Ensure that it's installed and accessible from the command line.

6. **sort command**: The `sort` command is used for sorting lines of text. Make sure it's installed and accessible from the command line.

7. **head command**: The `head` command is used for displaying the beginning lines of a file. Ensure that it's installed and accessible from the command line.

8. **cp command**: The `cp` command is used for copying files and directories. Make sure it's installed and accessible from the command line.

9. **find command**: The `find` command is used for searching files and directories. Ensure that it's installed and accessible from the command line.

10. **cut command**: The `cut` command is used for extracting sections from lines of files. Make sure it's installed and accessible from the command line.

11. **grep command**: The `grep` command is used for pattern matching and searching text. Ensure that it's installed and accessible from the command line.

12. **sed command**: The `sed` command is used for text stream editing. Ensure that it's installed and accessible from the command line.

## Usage

1. Clone this repository to your local machine or download the script file (`bds.sh`) manually.

2. Open a terminal and navigate to the directory where the script file is located.

3. Make the script file executable by running the following command:

   ```bash
   chmod +x bds.sh


4. Run the script by executing the following command:
   ```bash
   ./bds.sh


5. The script will check for the required dependencies and prompt you to install any missing ones. Follow the instructions to install the missing dependencies.

6. Once all dependencies are verified, the script will automatically update the BDS server to the latest version, copy necessary folders from the previous version if available, and compare/update the server properties file with user confirmation.

7. After the script completes, you will have the updated BDS server with the necessary files and configurations.

Please ensure that you have a working internet connection and sufficient permissions to install packages and update files on your system.

**Note:** This script assumes a Linux/Unix environment with the required dependencies available. It may not work as expected on other operating systems.
