%module fortran_callback

#ifndef __cplusplus
// Directly bind all functions: don't create proxy wrappers
%fortranbindc;
#endif

// Declare callback signature
%fortrancallback("%s");
#ifdef __cplusplus
extern "C" {
#endif
int binary_op(int left, int right);
void stupid_op(int left, int right);
void stupider_op();
#ifdef __cplusplus
} // end extern
#endif
%nofortrancallback;

// Create callbacks and define functions
%callback("%s_cb");

%inline %{
#ifdef __cplusplus
extern "C" {
#endif

int add(int left, int right) { return left + right; }
int mul(int left, int right) { return left - right; }

#ifdef __cplusplus
} // end extern
#endif
%}

%nocallback;

// Declare callback signature *and* create function with wrapper
%fortrancallback("%s_cb") call_binary;

%inline %{
#ifdef __cplusplus
extern "C" {
#endif

typedef int also_an_int;

typedef int (*binary_op_cb)(int, int);
int call_binary(binary_op_cb fptr, int left, also_an_int right)
{ return (*fptr)(left, right); }

#ifdef __cplusplus
} // end extern
#endif

typedef int (*noarg_cb)(void);
int call_things(noarg_cb fptr)
{ return (*fptr)(); }

typedef void (*one_int_cb)(int);
void also_call_things(one_int_cb fptr, int val)
{ return (*fptr)(val); }

%}

