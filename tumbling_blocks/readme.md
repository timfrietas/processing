This is the intital comit on a traditional "tumbling blocks" Amish quilt pattern.

The code needs bit of work: optimaization for drawing rows consistently when repeated as well as the replacement of some magic mumbers with some actual trig so that the code works with any intial cube size.  It is worth noting that although P3D is called in size() it isn't used at all (yet)--the "cubes" are actually three quad() diamond shapes rotated 120º to create a pattern.

The next commit is likely to focus on dynamic or stochastic colors as well as hopefully addressing some of the above.

![](https://github.com/timfrietas/processing/blob/master/tumbling_blocks/tumblingblocks.png)
