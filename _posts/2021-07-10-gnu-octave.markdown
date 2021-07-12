---
title:  "Gnu Octave - Unittests"
date:   2021-07-10 00:00:01 -0700
categories: data
tags: [octave,data]

---
# Built-In Unit Tests

- [https://wiki.octave.org/Tests]()

- Save the test at the bottom of the matlab file
  - Tests will automatically be discovered and run by runtests('./') 

{% highlight matlab %}

%!test
%! a = [0 1 0 0 3 0 0 5 0 2 1];
%! b = [2 5 8 10 11];
%! for i = 1:5
%!   assert (find (a, i), b(1:i))
%! endfor

runtests ('./')

{% endhighlight %}