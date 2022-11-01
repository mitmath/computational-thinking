---
title: "Class reviews"
tags: ["welcome"]
order: 2.2123
layout: "md.jlmd"
---


# Student feedback


<div class="student-feedback">

$(let
  feedback = [
    (
      "Applications Feedback", 
      "Spring 2020", 
      @htl("<p>The Introduction to Computational Thinking with Julia class is a welcome departure from the paradigm of teaching the canonical computer science examples such as sorting algorithms and graph search that are often overused in introductory curricula.</p><p>The class delves into real-world applications from the very beginning in a way that gives students an opportunity to be excited about the possibilities of computer science and mathematical modelling all while learning how to harness the power and elegance of the modern language of Julia.</p>"),
    ),
    (
      "Class Feedback", 
      "Spring 2020", 
      @htl("<p>This is one of the best classes I have ever taken. I like how the content is divided into four main real-world applications of computational thinking, which made learning very enjoyable and also made working with Julia easier for me.</p><p>I also found it amazing that this class provided applications of topics in differential equations and linear algebra classes and added a new way to view them. Unfortunately, I haven't found a similar class on computational thinking for the spring as the skills I gain are very practical and needed in research (I was impressed by the number of MISTI research opportunities that asked for experience with agent-based modeling or modeling in general.)</p>"),
    ),
    (
      "Website Feedback", 
      "Spring 2020", 
      @htl("<p>The class website made the class lectures and homework easy to find in addition to the GitHub page and canvas. - The Discord channel and Piazza also made it easier to ask questions and see other students' questions and comments. - The feedback for assignments was very clear, and the instructors were willing to explain my mistakes further by email.</p>"),
    ),
    (
      "Lecture Feedback", 
      "Spring 2020", 
      @htl("<p>The synchronous lectures were very comfortable, and the instructors encouraged us to ask questions.</p>"),
    )
  ]
  
  [
    @htl("""
    <div class="card">
    <div class="card-container">
    <h3 class="title">$(f[1])
    </h3>
    <div class="semester">$(f[2])
    </div>
    $(f[3])
    </div>
    </div>
    """)
    for f in feedback
  ]
end)

</div>

# What other people are saying

<blockquote class="twitter-tweet"><a style="font-size:1.2em" href="https://medium.com/towards-artificial-intelligence/mits-free-online-course-to-learn-julia-the-rising-star-b00a0e762dfc">MIT's  Free Online Course to Learn Julia — The Rising Star</a> &mdash; <em>Review of 18.S191 by Towards AI Newsletter</em></blockquote>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">the course is exceptional🎇🎇🎇</p>&mdash; YT Cai (@Yitao_CAI) <a href="https://twitter.com/Yitao_CAI/status/1338877387510059014?ref_src=twsrc%5Etfw">December 15, 2020</a></blockquote>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I cannot recommend this class enough, it’s awesome. <a href="https://t.co/4BsBEygeLd">https://t.co/4BsBEygeLd</a></p><br>&mdash; James Doss-Gollin (@jdossgollin) <a href="https://twitter.com/jdossgollin/status/1339013228194451456?ref_src=twsrc%5Etfw">December 16, 2020</a></blockquote> 


<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
