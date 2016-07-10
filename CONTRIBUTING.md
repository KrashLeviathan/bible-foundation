## Adding Posts to the Blog

**DO NOT modify the `blog.html` file or any files in the `posts/`
directory!**

Everything in the `posts/` directory is generated from markdown files
in the `_posts/` directory, and gets replaced when the script
`convert_markdown_to_html.sh` is run from the `_posts/` directory.
The `blog.html` file also gets generated by this script.
The intent was to make it easier for someone without web development
experience to add new blog posts to the site.

### Setup

#### Bash Environment

The script runs in bash, which is native to Mac or Linux. To run the
script on Windows, you need to download [win-bash](http://win-bash.sourceforge.net/)
first. You will probably also need to download [UnxUtils](http://unxutils.sourceforge.net/),
which is basically a bunch of basic GNU utilities that come standard
on Mac and Linux. *If someone gets this working on Windows you should
make a pull request to update this CONTRIBUTING.md doc, because I
haven't actually tested it on Windows myself.*

#### Other Bash Utils Needed

- **tidy**: Used to tidy up the html files after creation.
- **markdown (a python library)**: Used to do the markdown-to-html
  conversion. [Installation instructions can be found here]
  (https://pythonhosted.org/Markdown/install.html). Python can be
  [downloaded here](https://www.python.org/downloads/) or installed
  with a package manager program such as brew; however, it comes
  standard, so you likely already have it installed.

### Writing a Blog Post

Write new blog posts in the `_posts/` directory in an appropriate
sub-folder. The posts are written in markdown format.

[Markdown syntax help can be found here.](https://daringfireball.net/projects/markdown/syntax)

### Running the Script

From the bash environment, navigate to the `_posts/` directory and
run `bash convert_markdown_to_html.sh`. Everything in the `posts/`
directory should now be updated, as well as `blog.html` in the root
directory.

### Testing the Post

Make sure to open up the website locally and test out new changes to
make sure everything looks as expected.


## Low Bandwidth Guidelines

I've been using this website as a guide during development:

[Aptivate's Web Design Guidelines for Low Bandwidth]
(http://www.aptivate.org/webguidelines/Home.html)

If you want to contribute, you should at least read the [Top Ten Tips]
(http://www.aptivate.org/webguidelines/TopTen.html) page. The site
goes into much greater detail, though, so readings the rest of it
is not a bad idea either.

NOTE: In the interest of keeping page sizes small, I've avoided pulling
in the jQuery library or any other fancy frameworks that might add
bloat.

## Security

This is especially important in a ministry such as this one, where
bibles are often sent into countries hostile to the gospel. If we're
not careful with what we put on the internet (and with what gets
mailed), it can result in fellow Christians getting persecuted. Defer
to Jerry on all judgement calls in this matter.

## Other Things to Keep in Mind

- Low bandwidth design is a *must*, since the website will be consumed
  in developing countries.
- All legacy links from the old site must be redirected to appropriate
  links on the new site.
- Search engine optimization is working wonderfully for the old site.
  Copy whatever metadata needs to be copied from the old site and
  make changes/updates with caution.
- The networking idea is simple and must be presented in a way that is
  easy to digest. Promoters --> Collection Centers --> International
  Shippers.
- Automate the networking process
  - Make it easier for people to contribute without much personal
    guidance. Communication between Bible Foundation and its volunteers
    often breaks down, so volunteers should be able to work autonomously
    based on however involved they want to be.
  - Make it easy to search for churches near collection centers.
- Some of the information being migrated from the old website can be
  re-written to be less verbose, but all writings need to get approved
  by Jerry. He has a lot of experience in this ministry and in
  international communications. Plus he's in charge. ;-)
- **Make it clear about how to get involved!** A big problem with the
  old website is that people would visit and *want* to get involved,
  but they didn't know how.
- Make sure the history of the organization is on display somewhere,
  since they've been around almost 30 years and have done so much. The
  decades of experience are strong proof of credibility.
- Look into creating an email subscription service for people who want
  to receive blog updates via email.