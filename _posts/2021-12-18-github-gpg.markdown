---
title:  "Github.com GPG signing"
date:   2021-12-26 00:00:01 -0700
categories: development
tags: [github]

---
# Configure git to sign all commits

[https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key])

# Generate new gpg key

- Point source code manager's tool path to: C:\Program Files\Git\bin\git.exe

**Open Git bash terminal.**

{% highlight bash %}

which gpg
gpg --version
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
gpg --armor --export ABC123
gpg --gen-revoke ABC123
git config --global user.signingkey ABC123
git config --global commit.gpgsign true
git config --global gpg.program "/c/Program Files (x86)/GnuPG/bin/gpg.exe"

{% endhighlight %}