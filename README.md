Peter Shirley's Ray Tracing Minibooks in Nim
============================================

This repo is a source port of Peter Shirley's Ray Tracing Minibooks from C++
over to the [Nim language](http://nim-lang.org/).

The official repo page can be found on GitLab:
https://gitlab.com/define-private-public/PeterShirley-RayTracing-Nim
If you have any issues with the source code, please report issues there.  Any
other places that host this code should be treated as mirrors.

I've tried to keep the source code as simple as possible, so it probably isn't
as optimized as it could be.  I've also tried to keep it as close as possible to
the original source (e.g. naming conventions and structure), but a few times
I've taken liberties for the sake simplicity (e.g. see `book1/vec3.nim`).

Since I haven't gotten myself to reading all of the books yet, this is still a
work in progress.  So please ignore that `working/` directory for the moment.



Ray Tracing in One Weekend
--------------------------
![Ray Tracing in One Weekend](https://gitlab.com/define-private-public/PeterShirley-RayTracing-Nim/raw/master/renders/book1.png)

[Amazon link](https://www.amazon.com/Ray-Tracing-Weekend-Minibooks-Book-ebook/dp/B01B5AODD8)
-- [Original C++ Repo](https://github.com/petershirley/raytracinginoneweekend)

