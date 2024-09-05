void myfunction2(char32[] ptr);
bool CanFillBottle() : default false;

T Cond<T>(bool cond, T a, T b)
{
	return cond ? a : b;
}

namespace a {
    namespace b {
    }
    namespace c::d {
    }
    untyped data[2];
    ffc script ffc0 {
        int a;
        void run(){}
    }
    void f(){}
}

@Author("Connor"),
@Attribute0("a0")
ffc script ffc1 {
    using namespace a::b;
    void run() {
        int x = this->X;
    }
}

void myfunction()
{
    int a = 3, b = 1L;
    int c = a ? a+1 : a;
    bool d = 0b1 ^^ 1b;
    int e = .5;
    int f = Game->Misc[0] |= 1 + (Game->Misc[0] |= 1);
    a = b = 1;
    const int g = 1Lb + 1bL;
    int h = <int>(1 + a);
    // int m = 1 ^^^ 1;  // TODO !
    int[] n = "a" "s" "d";
    // TODO ! rm DOUBLESTAR
    bool bools[3 + 3];
    a::f();
    ffc1.run();
    using namespace a;

    if (int v = 1)
    {
        Trace(v);
    }

    switch (a)
	{
        case 0:
            Trace(1);
            break;
        case 1 + 0:
        {
            Trace(1);
            break;
        }
        case 1 + 0 ... 3:
        {
            Trace(1);
            break;
        }
        case 10: unless (Input->Button[0]) break; else break;
    }

    Game->Counter[CR_KEYS]++;
    unless (a)
    {
        int catsizes[] = a ? {a?5:4,5,5} : {3,2,3};
    }
    unless (a) switch (a) {
        default: return;
    }
    unless (a) return;

    int count = Link->X;
    int i = count ? 1 : 0;
    for (i = 0; i; ++i) if (i) Trace(i);
    for (int i = -256; i <= 0; i += 4) {}
    for (; i!= 0;){}
    for (i = 0; i; ++i, a++);

    while (true)
    {
        #option NO_ERROR_HALT on
        Trace(count);
        count += 1;
        Waitframe();
    }

    do Trace(1);
    while (true) // yes, no semicolon.

    auto poses = {1, 2, 3};
    for (pos : poses) Trace(pos);
}

enum 
{
    BLAH_1,
    BLAH_2,
    BLAH_3 = 4 + 3
};
enum GridLock
{
    GRID_NONE,
    GRID_HALF,
    GRID_FULL
};

// always using namespace NAME;
CONST_ASSERT(1 == 1, "yup");
