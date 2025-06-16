Git Java Formatting Conflict Resolver
=====================================

This repository contains a simple bash script designed to automate the resolution of common Git merge conflicts that arise purely from differences in code formatting within Java files.

Table of Contents
-----------------

* [Overview](#overview "null")
* [How it Works](#how-it-works "null")
* [Prerequisites](#prerequisites "null")
* [Usage](#usage "null")
* [Important Notes](#important-notes "null")

Overview
--------

When merging Git branches, developers often encounter conflicts where the underlying code logic is the same, but the formatting (indentation, line breaks, brace style, etc.) differs between the branches. Manually resolving these "formatting conflicts" can be tedious and time-consuming.

This script streamlines this process by:

1. Identifying conflicted `.java` files.

2. Extracting the "base" (common ancestor), "ours" (current branch), and "theirs" (incoming branch) versions of each conflicted file.

3. Applying a specified code formatting tool to all three versions.

4. Performing a three-way merge on these _formatted_ versions, which typically resolves purely formatting-related differences automatically.

5. Saving the resolved, formatted file back into your working directory.

How it Works
------------

The script leverages Git's ability to extract specific file versions from the merge index (`:1` for base, `:2` for ours, `:3` for theirs). For each conflicted Java file:

1. It retrieves the content of the base version and stores it in a temporary file (`base_temp`).

2. It retrieves the content of the incoming ("theirs") version and stores it in another temporary file (`theirs_temp`).

3. It retrieves the content of your current ("ours") version and overwrites the original conflicted file with it.

4. A crucial step is applying a placeholder `format` command (which you must configure to your actual formatter, e.g., `google-java-format -i`) to `base_temp`, `theirs_temp`, and the original `$file` (now containing the formatted "ours" version).

5. Finally, `git merge-file` is used to perform a three-way merge with the formatted `ours` version as the target, and `base_temp` and `theirs_temp` as the other inputs. Because all versions have been consistently formatted, trivial formatting differences often disappear, allowing `git merge-file` to resolve them cleanly.

Prerequisites
-------------

Before running this script, ensure you have:

* **Git:** Installed and configured on your system.

* **A Java Code Formatter:** This script _requires_ an external command-line tool that can format Java code in-place. Examples include:

  * [Google Java Format](https://github.com/google/google-java-format "null")

  * [Prettier (with Java plugin)](https://prettier.io/docs/en/plugins.html#java "null")

  * Any other tool that accepts a file path and modifies the file content according to your coding standards.

Usage
-----

1. **Save the script:** Save the provided bash script (e.g., as `resolve_java_formatting_conflicts.sh`) in a convenient location within your Git repository (e.g., at the root or in a `scripts/` directory).

2. **Make it executable:**

        chmod +x resolve_java_formatting_conflicts.sh
        
        

3. **Configure the `format` command:** **This is the most important step.** Open the script in a text editor. Locate the line that contains `format "$base_temp"`, `format "$theirs_temp"`, and `format "$file"`. **Replace `format` with the actual command for your Java formatter.**

    * **Example (using Google Java Format):** Change:

            format "$base_temp"
            # ...
            format "$theirs_temp"
            # ...
            format "$file"
            
            

        To:

            google-java-format -i "$base_temp"
            # ...
            google-java-format -i "$theirs_temp"
            # ...
            google-java-format -i "$file"
            
            

    * Ensure your formatter command is correct and available in your system's `PATH`.

4. **Run the script:** Navigate to your Git repository's root directory in your terminal and execute the script:

        ./resolve_java_formatting_conflicts.sh
        
        

The script will process all conflicted `.java` files. If it successfully resolves a conflict, the file will be updated in your working tree, and you can then `git add` the file to stage the resolution. If actual logic conflicts remain after formatting, the file will still show merge conflict markers, but the surrounding code will be consistently formatted, making manual resolution easier.

Important Notes
---------------

* This script is most effective for conflicts that are _solely_ due to formatting differences.

* If genuine code logic conflicts exist alongside formatting differences, the script will still format the code, but `git merge-file` might leave conflict markers for the logical discrepancies. You will then need to resolve these remaining conflicts manually.

* Always inspect the changes after running the script (`git diff`) to ensure the resolution is as expected.

* Consider running this script as part of a Git hook (e.g., `pre-rebase` or `post-merge`) if you want to automate it further, but be cautious and understand the implications.
