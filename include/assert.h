#ifndef ASSERT_H
#define ASSERT_H

#ifdef NDEBUG
#define assert(EX) ((void)0)
#else
void __assert(const char *, const char *, int);
#define assert(EX) ((EX) ? ((void)0) : __assert("EX", __FILE__, __LINE__))
#endif

#endif
