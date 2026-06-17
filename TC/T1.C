#include <graphics.h>
#include <conio.h>
#define y(y) ((y*2-1)*10)
#define x(x) ((x*2-1)*10)
#define R 10
void GraphInit();
int main(void)
{   int i,j;
	GraphInit();
	for(i=1;i<=24;i++)
	{  for(j=1;j<=32;j++){
			setfillstyle(SOLID_FILL,2);
			setcolor(2);
			fillellipse((j*2-1)*10,(i*2-1)*10,10,10);
		}
	}
	setfillstyle(SOLID_FILL,4);
	setcolor(4);
    fillellipse(x(10),y(20),R,R);
    fillellipse(x(20),y(20),R,R);
    fillellipse(x(14),y(20),R,R);
	fillellipse(x(16),y(20),R,R);
    fillellipse(x(18),y(20),R,R);
    fillellipse(x(20),y(20),R,R);
    fillellipse(x(22),y(20),R,R);
    fillellipse(x(24),y(20),R,R);

    fillellipse(x(11),y(15),R,R);
    fillellipse(x(15),y(15),R,R);
    fillellipse(x(19),y(15),R,R);
    fillellipse(x(23),y(15),R,R);

    fillellipse(x(13),y(10),R,R);
    fillellipse(x(21),y(10),R,R);

    fillellipse(x(17),y(5),R,R);

	setcolor(4);

	outtextxy(7, 7, "b");

	getch();
	closegraph();
	return 0;
}

void GraphInit()
{
	int gdriver = DETECT, gmode;
	initgraph(&gdriver,&gmode,"D:\\TC");
}