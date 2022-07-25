# Contributing to MyFirstBuiltbyJenkinsApplications

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

The following is a set of guidelines for contributing to MyFirstBuiltbyJenkinsApplications. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

#### Table Of Contents

[Code of Conduct](#code-of-conduct)

[I don't want to read this whole thing, I just have a question!!!](#i-dont-want-to-read-this-whole-thing-i-just-have-a-question)

[What should I know before I get started?](#what-should-i-know-before-i-get-started)
* [Releases](#releases)

[How Can I Contribute?](#how-can-i-contribute)
* [Reporting Bugs](#reporting-bugs)
* [Suggesting Enhancements](#suggesting-enhancements)
* [Your First Code Contribution](#your-first-code-contribution)
* [Pull Requests](#pull-requests)

[Styleguides](#styleguides)
* [Git Commit Messages](#git-commit-messages)
* [Specs Styleguide](#specs-styleguide)
* [Documentation Styleguide](#documentation-styleguide)


## Code of Conduct

This project and everyone participating in it is governed by the [Jenkins Code of Conduct](https://www.jenkins.io/project/conduct/). By participating, you are expected to uphold this code. 

## I don't want to read this whole thing I just have a question!!!

> **Note:** Please don't file an issue to ask a question. You'll get faster results by using the resources below.

We use the forum where the community chimes in with helpful advice if you have questions.

* [Jenkins Forum](https://community.jenkins.io/)

## What should I know before I get started?

### Releases

We are using [Semantic Versioning](http://semver.org/) for our releases thanks to [Dipien Semantic Version Gradle Plugin](Semantic Version Gradle Plugin).
On android you have to define two version fields for an app:
 * Version code (`android:versionCode` on your `AndroidManifest.xml`). The version code is an incremental integer value that represents the version of the application code. The greatest value Google Play allows for a version code is `2100000000`.
 * Version name (`android:versionName` on your `AndroidManifest.xml`). The version name is a string value that represents the "friendly" version name displayed to the users.
You can get more details [here](http://developer.android.com/tools/publishing/versioning.html#appversioning).

It's a good practice to have a direct relationship between both versions to avoid confusion during the development and release process. At least, you should be able to infer the version name given a version code. As described [here](http://developer.android.com/google/play/publishing/multiple-apks.html#VersionCodes), the official documentation proposes using a version code scheme that associates the version code and name, and also supports multiple APKs. The plugin uses that scheme but with some changes to also support Semantic Versioning.

The Semantic Version Gradle Plugin automatically generates and configures the `versionCode` and `versionName` on the `defaultConfig` section at build time. It uses the version defined at the root `build.gradle[.kts]` to configure those fields. **It's important to remember you don't have to set those fields on the defaultConfig section.**

When building, the process searches for an existing release with the same name on GitHub. If it doesn't find one, it creates a new one.
The type of release is determined by the version suffix :
 * `ALPHA` or `BETA`: release type is `pre-release`
 * `SNAPSHOT`: no release
 * `RELEASE`: release type is `release` 
 * anything else: `draft` release

The release notes are generated automatically by [`gh`](https://cli.github.com/manual/gh_release_create). If the [release](https://github.com/gounthar/MyFirstAndroidAppBuiltByJenkins/releases) goes well on GitHub, we then switch to creating one on Google Play with the same name and simplified release notes (because of the [500 characters limit](https://www.iwantanelephant.com/blog/2022/04/06/how-to-create-your-android-release-notes-easily/)).

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for MyFirstBuiltbyJenkinsApplications. Following these guidelines helps maintainers and the community understand your report :pencil:, reproduce the behavior :computer: :computer:, and find related reports :mag_right:.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) as you might find out that you don't need to create one. When you are creating a bug report, please [include as many details as possible](#how-do-i-submit-a-good-bug-report). Fill out [the required template](https://github.com/gounthar/MyFirstAndroidAppBuiltByJenkins/blob/main/.github/ISSUE_TEMPLATE/bug_report.md), the information it asks for helps us resolve issues faster.

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

#### Before Submitting A Bug Report

* **Perform a [cursory search](https://github.com/search?q=+is%3Aissue+user%3Agounthar)** to see if the problem has already been reported. If it has **and the issue is still open**, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/). Create an issue on that repository and provide the following information by filling in [the template](https://github.com/gounthar/MyFirstAndroidAppBuiltByJenkins/blob/main/.github/ISSUE_TEMPLATE/bug_report.md).

Explain the problem and include additional details to help maintainers reproduce the problem:

* **Use a clear and descriptive title** for the issue to identify the problem.
* **Describe the exact steps which reproduce the problem** in as many details as possible. When listing steps, **don't just say what you did, but explain how you did it**. 
* **Provide specific examples to demonstrate the steps**. Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples. If you're providing snippets in the issue, use [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
* **Explain which behavior you expected to see instead and why.**
* **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem. 
* **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened and share more information using the guidelines below.

Provide more context by answering these questions:

* **Did the problem start happening recently** (e.g. after updating to a new version of Atom) or was this always a problem?
* If the problem started happening recently, **can you reproduce the problem in an older version of the application?** What's the most recent version in which the issue doesn't happen? You can download older versions from [the releases page](https://github.com/gounthar/MyFirstAndroidAppBuiltByJenkins/releases).
* **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.

Include details about your configuration and environment:

* **Which version of Android are you using?** (e.g. `Android 6.0`)
* **Are you running the App in an emulator or with a non manufacturer supplied version of Android?** If so, which emulator are you using and which operating systems and versions are used

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for Atom, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion :pencil: and find related suggestions :mag_right:.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion). Fill in [the template](https://github.com/gounthar/MyFirstAndroidAppBuiltByJenkins/blob/main/.github/ISSUE_TEMPLATE/feature_request.md), including the steps that you imagine you would take if the feature you're requesting existed.

#### Before Submitting An Enhancement Suggestion

* **Perform a [cursory search](https://github.com/search?q=+is%3Aissue+user%3Agounthar)** to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://guides.github.com/features/issues/). Create an issue on that repository and provide the following information:

* **Use a clear and descriptive title** for the issue to identify the suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
* **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
* **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part of the App which the suggestion is related to. 
* **Specify the name and version of the OS you're using.**

### Your First Code Contribution

Unsure where to begin contributing to MyFirstBuildbyJenkinsApplication? You can start by looking through these `beginner` and `help-wanted` issues:

* [Beginner issues][beginner] - issues which should only require a few lines of code, and a test or two.
* [Help wanted issues][help-wanted] - issues which should be a bit more involved than `beginner` issues.

Both issue lists are sorted by total number of comments. While not perfect, number of comments is a reasonable proxy for impact a given change will have.

#### Local development

### Pull Requests

The process described here has several goals:

- Maintain MyFirstBuildbyJenkinsApplication's quality
- Fix problems that are important to users

Please follow these steps to have your contribution considered by the maintainers:

1. Follow all instructions in [the template](PULL_REQUEST_TEMPLATE.md)
2. Follow the [styleguides](#styleguides)
3. After you submit your pull request, verify that all [status checks](https://help.github.com/articles/about-status-checks/) are passing <details><summary>What if the status checks are failing?</summary>If a status check is failing, and you believe that the failure is unrelated to your change, please leave a comment on the pull request explaining why you believe the failure is unrelated. A maintainer will re-run the status check for you. If we conclude that the failure was a false positive, then we will open an issue to track that problem with our status check suite.</details>

While the prerequisites above must be satisfied prior to having your pull request reviewed, the reviewer(s) may ask you to complete additional design work, tests, or other changes before your pull request can be ultimately accepted.

## Styleguides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or fewer
* Reference issues and pull requests liberally after the first line
* When only changing documentation, include `[ci skip]` in the commit title
* Consider starting the commit message with an applicable emoji:
    * :art: `:art:` when improving the format/structure of the code
    * :racehorse: `:racehorse:` when improving performance
    * :non-potable_water: `:non-potable_water:` when plugging memory leaks
    * :memo: `:memo:` when writing docs
    * :penguin: `:penguin:` when fixing something on Linux
    * :apple: `:apple:` when fixing something on macOS
    * :checkered_flag: `:checkered_flag:` when fixing something on Windows
    * :bug: `:bug:` when fixing a bug
    * :fire: `:fire:` when removing code or files
    * :green_heart: `:green_heart:` when fixing the CI build
    * :white_check_mark: `:white_check_mark:` when adding tests
    * :lock: `:lock:` when dealing with security
    * :arrow_up: `:arrow_up:` when upgrading dependencies
    * :arrow_down: `:arrow_down:` when downgrading dependencies
    * :shirt: `:shirt:` when removing linter warnings

### Specs Styleguide

- Include thoughtfully-worded, well-structured [Jasmine](https://jasmine.github.io/) specs in the `./spec` folder.
- Treat `describe` as a noun or situation.
- Treat `it` as a statement about state or how an operation changes state.

#### Example

```coffee
describe 'a dog', ->
 it 'barks', ->
 # spec here
 describe 'when the dog is happy', ->
  it 'wags its tail', ->
  # spec here
```

### Documentation Styleguide

* Use [Markdown](https://daringfireball.net/projects/markdown).
* Use [GitHub flavored markdown](https://guides.github.com/features/mastering-markdown/) for code blocks.

## Additional Notes

### Issue and Pull Request Labels

This section lists the labels we use to help us track and manage issues and pull requests. Most labels are used across all Atom repositories, but some are specific to `atom/atom`.

[GitHub search](https://help.github.com/articles/searching-issues/) makes it easy to use labels for finding groups of issues or pull requests you're interested in. 

The labels are loosely grouped by their purpose, but it's not required that every issue has a label from every group or that an issue can't have more than one label from the same group.