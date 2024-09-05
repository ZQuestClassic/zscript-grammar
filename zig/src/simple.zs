// #include "std.zh"
import "std.zh"

ffc script Maths
{
    void run()
    {
        int count = 1;
        while (true)
        {
            Trace(count);
            count += 1;
            Waitframe();
        }
    }
}
