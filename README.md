# Analysis of the Qur'an

While studying several Qur'an translations/interpretations I learnt about some intriguing numerical properties of the book.  I do not believe these properties change the meaning much or are prerequisite knowledge for anyone studying its message for the purpose of spiritual awakening.  Yet to me these properties where intriguing enough start an effort to replicate them.

In chapter 74 the 30th verse reads "Over it are nineteen", many see this as a hint that nineteen is of special significance to the book.  We can see 1 as the first and 9 as the last number of a decimal system, thereby 1-9 to a decimal system is like alpha-omega to the Greek alphabet.  In the New Testament's book of revelation we find several references to this conjunction of alpha and omega.

I do not subscribe to all of the claims people make about numeric analyses of the Qur'an.  I do feel some of properties are miraculous, yet I found them often hard to reproduce or ambiguously formulated.  My goal for this project is to make it extremely easy to replicate the analyses by anyone with basic programming skills.  Besides that I think programming languages -- being extremely formal compared to human laguages -- are particularly suitable to formulate the analyses.


## Results

The results can be found in the `html` folder in this reposity.  Just
download it and open it with a web browser.


## Installation

This software is written in the [Ruby prgramming language](http://ruby-lang.org).  The language is open source, therefor free.  Ruby's most important qualities are it being very close to English, to-the-point and programmer friendly.

To use this software you simply [install Ruby](http://www.ruby-lang.org/en/downloads) and [download this software](https://github.com/cies/quran-analysis/downloads).  You can use either Linux, Mac OSX or Windows -- though Linux and Mac OSX work a lot easier.

In Ruby land we can install libraries with the `gem` command.  Currently we only need one library for the `replicate-claims.rb` script, it is call `RSpec` and can be installed with:

        gem install rspec

The `gem` command should come with most installations of Ruby these days.

Currently this proejct comes with the following commands:

        replicate_claims.rb
        console.rb
        transform-yuksel.rb
        transform-tanzil.rb

There also exists a `Rakefile` to generate the `html` outputs, you can invoke it by executing `rake` from within the project folder.

The project also ships with to non-executable files, `quran.rb` and `arabic.rb`, they are used by the executables.

Good luck intalling and playing with this project.


# Todo

 * send out requests for code of previous attempts to write software replicating the analyses
 * seek help form those who went before me
 * add replications for more claims (curretly this project contains proof-of-concepts at best)
 * eventually move the code to RSpec for better readability and nice output
 * work towards a bunch of classes that can be used from the IRB) console


## Todo: a better console

 * a Quran class work be nice, it should be possible to conviently query and search through it.
 * queries could return a query object that can then be formatted to needs (w/-or-w/o words/chapter/verse/etc.)
 * some extentions to the String class would make our life easier
 * maybe a class that colors numbers green if they are a multiple of 19
 * a method to romanize arabic: it's so hard to read for me (alternating LtoR/RtoL)
 * move all extentions into a `core_ext` folder (refer to `awesome_print`)
 * make a small introduction to using these scripts in the README


## Tada

 * wrote a README to elaborate on the intention of my efforts
 * simple 'initial' letter count as first found by Khalifa Rashad has been implemented, but results in different counts
 * couting for the word 'Allah' has been implemented, resulting in different counts then found in literature
 * start a github project, sharing my efforts with a greater audience
 * added scripts that transform the original Quran texts (currently only Edip Yuksel's and the cleanest version of the tanzil.net texts are considered)



# Questions

 * why do some chapters have a line allocated for the initials and some dont?
 * why is the first bismallah not put on 1:0 while the others are
 * it seems that revised initial counts on submission.org yield more 19 claims than you made in your book -- why?


# License

Unless mentioned otherwise the license to this souftware is AGPL version 3.

The copy of the Qur'an text you find in this project is from [tanzil.net](http://www.tanzil.net) it contains a copyright notice at the end of the file and is released under the Creative Commons No-Derivatives license version 3.0.

The text of this README you are reading is released under the Creative Common Attribution Share-Alike license version 3.0.
